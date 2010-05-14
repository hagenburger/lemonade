module Lemonade
  def self.generate_sprites
    if $lemonade_sprites
      $lemonade_sprites.each do |sprite_name, sprite|
        sprite_image = Magick::Image.new(sprite[:width], sprite[:height]) do
          self.background_color = 'transparent'
        end
        y = 0
        sprite[:images].each do |image|
          file = File.join(Compass.configuration.images_path, image[:file])
          single_image  = Magick::Image::read(file).first
          sprite_image.composite!(single_image, image[:x], image[:y], Magick::OverCompositeOp)
        end
        file = File.join(Compass.configuration.images_path, "#{ sprite_name }.png")
        sprite_image.write file
      end
      $lemonade_sprites = nil
      $lemonade_space_bottom = 0
    end
  end
end