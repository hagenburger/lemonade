module Sass::Script::Functions

  def sprite_url(*args)
    url, position = sprite_url_and_position(*args)
    url
  end
  
  def sprite_position(*args)
    url, position = sprite_url_and_position(*args)
    position
  end
  
  def sprite_image(*args)
    url, position = sprite_url_and_position(*args)
    position = '0 0' == position.to_s ? '' : " #{position}"
    Sass::Script::String.new("#{url}#{position}")
  end  
  alias_method :sprite_img, :sprite_image

private

  def sprite_url_and_position(file, add_x = nil, add_y = nil, margin_top_or_both = nil, margin_bottom = nil)
    assert_type file, :String
    unless (file.to_s =~ %r(^"(.+/)?(.+?)/(.+?)\.(png|gif|jpg)"$)) == 0
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    dir, name, filename = $1, $2, $3
    filestr = File.join(Lemonade.sprites_path, file.to_s.gsub('"', ''))

    sprite = sprite_for("#{dir}/#{name}")
    image = image_for(sprite, filestr, add_x, add_y, margin_top_or_both, margin_bottom)

    # Create a temporary destination file so compass doesn't complain about a missing image
    FileUtils.touch File.join(Lemonade.images_path, "#{dir}#{name}.png")

    [generic_image_url("#{dir}#{name}.png"), background_position(-image[:y], add_x, add_y)]
  end

  def generic_image_url(image)
    if defined?(Compass)
      image_url(Sass::Script::String.new(image))
    else
      Sass::Script::String.new("url(#{image.inspect})")
    end
  end

  def background_position(y, add_x, add_y)
    x = add_x ? add_x.to_s : 0
    y += add_y.value if add_y
    Sass::Script::String.new("#{x} #{y}#{ 'px' unless y == 0 }")
  end

  def calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
    margin_top_or_both = margin_top_or_both ? margin_top_or_both.value : 0
    margin_top = (sprite[:margin_bottom] ||= 0) > margin_top_or_both ? sprite[:margin_bottom] : margin_top_or_both
    sprite[:margin_bottom] = margin_bottom ? margin_bottom.value : margin_top_or_both
    margin_top
  end

  def sprite_for(file)
    Lemonade.sprites[file] ||= {
        :height => 0,
        :width => 0,
        :images => [],
        :margin_bottom => 0
      }
  end
  
  def image_for(sprite, file, add_x, add_y, margin_top_or_both, margin_bottom)
    unless image = sprite[:images].detect{ |image| image[:file] == file }
      width, height = ChunkyPNG::Image.from_file(file).size
      margin_top = calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
      x = (add_x and add_x.numerator_units == %w(%)) ? add_x.value / 100 : 0
      y = sprite[:height] + margin_top
      sprite[:height] += height + margin_top
      sprite[:width] = width if width > sprite[:width]
      image = { :file => file, :height => height, :width => width, :x => x, :y => y }
      sprite[:images] << image
    end
    image
  rescue Errno::ENOENT
    raise Sass::SyntaxError, "#{file} does not exist in sprites_dir #{Lemonade.sprites_path}"
  rescue ChunkyPNG::SignatureMismatch
    raise Sass::SyntaxError, "#{file} is not a recognized png file, can't use for sprite creation"
  end
end
