module Sass::Script::Functions

  def sprite_url(file)
    dir, name, basename = extract_names(file)
    sprite = sprite_for("#{dir}#{name}")
    Sass::Script::SpriteInfo.new(:url, sprite)
  end

  def sprite_position(file, position_x = nil, position_y_shift = nil, margin_top_or_both = nil, margin_bottom = nil)
    sprite, sprite_item = sprite_url_and_position(file, position_x, position_y_shift, margin_top_or_both, margin_bottom)
    Sass::Script::SpriteInfo.new(:position, sprite, sprite_item, position_x, position_y_shift)
  end

  def sprite_image(file, position_x = nil, position_y_shift = nil, margin_top_or_both = nil, margin_bottom = nil)
    sprite, sprite_item = sprite_url_and_position(file, position_x, position_y_shift, margin_top_or_both, margin_bottom)
    Sass::Script::SpriteInfo.new(:both, sprite, sprite_item, position_x, position_y_shift)
  end
  alias_method :sprite_img, :sprite_image

  def sprite_files_in_folder(folder)
    assert_type folder, :String
    count = sprite_file_list_from_folder(folder).length
    Sass::Script::Number.new(count)
  end

  def sprite_file_from_folder(folder, n)
    assert_type folder, :String
    assert_type n, :Number
    file = sprite_file_list_from_folder(folder)[n.to_i]
    file = File.basename(file)
    Sass::Script::String.new(File.join(folder.value, file))
  end

  def sprite_name(file)
    dir, name, basename = extract_names(file)
    Sass::Script::String.new(name)
  end

  def image_basename(file)
    dir, name, basename = extract_names(file, :check_file => true)
    Sass::Script::String.new(basename)
  end

private

  def sprite_file_list_from_folder(folder)
    dir = File.join(Lemonade.sprites_path, folder.value)
    Dir.glob(File.join(dir, '*.png')).sort
  end

  def sprite_url_and_position(file, position_x = nil, position_y_shift = nil, margin_top_or_both = nil, margin_bottom = nil)
	image_path, sprite_name = get_image_path_and_sprite_name_for(file)
	
    sprite = sprite_for(sprite_name)
    sprite_item = image_for(sprite, image_path, position_x, position_y_shift, margin_top_or_both, margin_bottom)

    # Create a temporary destination file so compass doesn't complain about a missing image
    FileUtils.touch File.join(Lemonade.images_path, sprite_name)

    [sprite, sprite_item]
  end
  
  # ru: Получить путь до картинки (полный путь относительно подключённого sass файла или относительно Lemonade.images_path) и имя для спрайте
  # en: Get the path to image (full path relative to the imported sass file, or relatively Lemonade.images_path) and name for a sprite
  def get_image_path_and_sprite_name_for(file)
	dir, name, basename = extract_names(file, :check_file => true)
	
	# reset
    image_path = nil
	sprite_name = nil
	
    if (Lemonade.last_imported_full_filename != nil)
	  # ru: Если last_import_full_filename установлен, установить image_path относительно последнего импортированного sass файла
	  # en: If isset last_import_full_filename, set image_path relative to the last imported sass file.
	  image_path = File.join(File.dirname(Lemonade.last_imported_full_filename), file.value )
	  sprite_name = "#{ File.basename(Lemonade.last_imported_full_filename, ".scss") }_#{ name }"
      if !File.exist?(image_path)
	    # reset image_path
        image_path = nil
      end
	end

	if (image_path == nil)
	  # ru: Установить image_path относительно текущего sass file
	  # en: Set image_path relative to the current sass file
	  image_path = File.join(File.dirname(options[:filename]), file.value )
	  sprite_name = "#{ File.basename(options[:filename], ".scss") }_#{ name }"
	  if !File.exist?(image_path)
        image_path = nil
      end
	end
	
	if (image_path == nil)
	  # ru: Установить image_path относительно Lemonade.images_path
	  # en: Standard lemonade method. set image_path relative to the Lemonade.images_path
	  image_path = File.join(Lemonade.images_path, file.value)
	  sprite_name =  "#{ dir }#{ name }"
	end
	
	sprite_path = "#{ sprite_path }.png"

	[image_path, sprite_name]
  end
  
  def extract_names(file, options = {})
    assert_type file, :String
    unless (file.value =~ %r(^(.+/)?([^\.]+?)(/(.+?)\.(png))?$)) == 0
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    dir, name, basename = $1, $2, $4
    if options[:check_file] and basename.nil?
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    [dir, name, basename]
  end

  def sprite_for(file)
  
    file = "#{file}.png" unless file =~ /\.png$/
    Lemonade.sprites[file] ||= {
        :file => "#{file}",
        :height => 0,
        :width => 0,
        :images => [],
        :margin_bottom => 0
      }
  end

  def image_for(sprite, file, position_x, position_y_shift, margin_top_or_both, margin_bottom)
    image = sprite[:images].detect{ |image| image[:file] == file }
    margin_top_or_both ||= Sass::Script::Number.new(0)
    margin_top = margin_top_or_both.value #calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
    margin_bottom = (margin_bottom || margin_top_or_both).value
    if image
      image[:margin_top] = margin_top if margin_top > image[:margin_top]
      image[:margin_bottom] = margin_bottom if margin_bottom > image[:margin_bottom]
    else
      width, height = ChunkyPNG::Image.from_file(file).size
      x = (position_x and position_x.numerator_units == %w(%)) ? position_x : Sass::Script::Number.new(0)
      y = sprite[:height] + margin_top
      y = Sass::Script::Number.new(y, y == 0 ? [] : ['px'])
      image = {
        :file => file,
        :height => height,
        :width => width,
        :x => x,
        :margin_top => margin_top,
        :margin_bottom => margin_bottom,
        :index => sprite[:images].length
      }
      sprite[:images] << image
    end
    image
  rescue Errno::ENOENT
    raise Sass::SyntaxError, "#{file} does not exist in sprites_dir #{Lemonade.sprites_path}"
  rescue ChunkyPNG::SignatureMismatch
    raise Sass::SyntaxError, "#{file} is not a recognized png file, can't use for sprite creation"
  end

end
