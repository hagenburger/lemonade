module Lemonade
  def self.generate_sprites
    if $lemonade_sprites
      $lemonade_sprites.each do |sprite_name, sprite|
        sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)
        y = 0
        sprite[:images].each do |image|
          file = File.join(Compass.configuration.images_path, image[:file])
          single_image  = ChunkyPNG::Image.from_file(file)
          x = (sprite[:width] - image[:width]) * image[:x]
          # The following line is buggy (too dark anti-aliasing):
          # sprite_image.compose single_image, x, image[:y]
          # This works as expected:
          0.upto image[:width] - 1 do |xx|
            0.upto image[:height] - 1 do |yy|
              sprite_image[x + xx, y + yy] = single_image[xx, yy]
            end
          end
        end
        file = File.join(Compass.configuration.images_path, "#{ sprite_name }.png")
        sprite_image.save file
      end
      $lemonade_sprites = nil
    end
  end
end