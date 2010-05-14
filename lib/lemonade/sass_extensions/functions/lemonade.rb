module Lemonade::SassExtensions::Functions::Lemonade

  def sprite_image(file, add_x = nil, add_y = nil, margin_top_or_both = nil, margin_bottom = nil)
    assert_type file, :String
    unless (file.to_s =~ %r(^"(.+/)?(.+?)/(.+?)\.(png|gif|jpg)"$)) == 0
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    dir, name, filename = $1, $2, $3
    height = image_height(file).value
    width = image_width(file).value
    margin_top = calculate_margin_top(margin_top_or_both, margin_bottom)

    $lemonade_sprites ||= {}
    sprite = $lemonade_sprites["#{ dir }/#{ name }"] ||= { :height => 0, :width => 0, :images => [] }
    x = 0
    y = sprite[:height] + margin_top
    sprite[:height] += height + margin_top
    sprite[:width] = width if width > sprite[:width]
    sprite[:images] << { :file => file.to_s.gsub('"', ''), :height => height, :width => width, :x => x, :y => y }

    position = background_position(x, y, add_x, add_y)
    file = image_url(Sass::Script::String.new("#{ dir }#{ name }.png"))
    Sass::Script::String.new("#{ file }#{ position }")
  end
  
private

  def background_position(x, y, add_x, add_y)
    y = -y
    x += add_x.value if add_x
    y += add_y.value if add_y
    unless x == 0 and y == 0
      " #{ x }#{ 'px' unless x == 0 } #{ y }#{ 'px' unless y == 0 }"
    end
  end
  
  def calculate_margin_top(margin_top_or_both, margin_bottom)
    margin_top_or_both = margin_top_or_both ? margin_top_or_both.value : 0
    margin_top = ($lemonade_margin_bottom ||= 0) > margin_top_or_both ? $lemonade_margin_bottom : margin_top_or_both
    $lemonade_margin_bottom = margin_bottom ? margin_bottom.value : margin_top_or_both
    margin_top
  end

end
