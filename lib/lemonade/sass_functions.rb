module Sass::Script::Functions

  def sprite_image(file, add_x = nil, add_y = nil, margin_top_or_both = nil, margin_bottom = nil)
    assert_type file, :String
    unless (file.to_s =~ %r(^"(.+/)?(.+?)/(.+?)\.(png|gif|jpg)"$)) == 0
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    dir, name, filename = $1, $2, $3
    filestr = File.join(Lemonade.sprites_path, file.to_s.gsub('"', ''))

    sprite = Lemonade.sprites["#{dir}/#{name}"] ||= {
        :height => 0,
        :width => 0,
        :images => [],
        :margin_bottom => 0
      }

    if image = sprite[:images].detect{ |image| image[:file] == filestr }
      y = image[:y]
    else
      begin
        width, height = ChunkyPNG::Image.from_file(filestr).size
        margin_top = calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
        x = (add_x and add_x.numerator_units == %w(%)) ? add_x.value / 100 : 0
        y = sprite[:height] + margin_top
        sprite[:height] += height + margin_top
        sprite[:width] = width if width > sprite[:width]
        sprite[:images] << { :file => filestr, :height => height, :width => width, :x => x, :y => y }
      rescue Errno::ENOENT
        raise Sass::SyntaxError, "#{file} does not exist in sprites_dir #{Lemonade.sprites_path}"
      rescue ChunkyPNG::SignatureMismatch
        raise Sass::SyntaxError, "#{file} is not a recognized png file, can't use for sprite creation"
      end
    end

    # Create a temporary destination file so compass doesn't complain about a missing image
    FileUtils.touch File.join(Lemonade.images_path, "#{dir}#{name}.png")

    position = background_position(-y, add_x, add_y)
    output_file = generic_image_url("#{dir}#{name}.png")
    Sass::Script::String.new("#{output_file}#{position}")
  end
  alias_method :sprite_img, :sprite_image

private
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
    unless (add_x.nil? or add_x.value == 0) and y == 0
      " #{x} #{y}#{ 'px' unless y == 0 }"
    end
  end

  def calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
    margin_top_or_both = margin_top_or_both ? margin_top_or_both.value : 0
    margin_top = (sprite[:margin_bottom] ||= 0) > margin_top_or_both ? sprite[:margin_bottom] : margin_top_or_both
    sprite[:margin_bottom] = margin_bottom ? margin_bottom.value : margin_top_or_both
    margin_top
  end

end
