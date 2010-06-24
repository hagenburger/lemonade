module Lemonade
  def self.generate_sprites
    if $lemonade_sprites
      $lemonade_sprites.each do |sprite_name, sprite|
        #sprite_image = Magick::Image.new(sprite[:width], sprite[:height]) do
        sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)
        y = 0
        sprite[:images].each do |image|
          file = File.join(Compass.configuration.images_path, image[:file])
          #single_image  = Magick::Image::read(file).first
          single_image  = ChunkyPNG::Image.from_file(file)
          x = (sprite[:width] - image[:width]) * image[:x]
          #sprite_image.composite!(single_image, x, image[:y], Magick::OverCompositeOp)
          sprite_image.compose single_image, x, image[:y]
        end
        file = File.join(Compass.configuration.images_path, "#{ sprite_name }.png")
        #sprite_image.write file
        sprite_image.save file, :fast_rgba
      end
      $lemonade_sprites = nil
      $lemonade_space_bottom = 0
    end
  end
end