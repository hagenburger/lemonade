require 'yaml'

module Lemonade
  def self.generate_sprites
    affected_css_filenames = []
    if $lemonade_sprites
      $lemonade_sprites.each do |sprite_name, sprite|
        if sprite_changed?(sprite_name, sprite)
          sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)
          y = 0
          sprite[:images].each do |image|
            file = File.join(Compass.configuration.images_path, image[:file])
            single_image  = ChunkyPNG::Image.from_file(file)
            x = (sprite[:width] - image[:width]) * image[:x]
            sprite_image.replace single_image, x, image[:y]
          end
          file = File.join(Compass.configuration.images_path, "#{ sprite_name }.png")
          sprite_image.save file

          remember_sprite_info!(sprite_name, sprite)
          affected_css_filenames |= sprite[:css_filenames]
        end
      end
      $lemonade_sprites = nil
    end
    affected_css_filenames
  end


  private

  def self.sprite_info_file(sprite_name)
    File.join(Compass.configuration.images_path, "#{sprite_name}.sprite_info.yml")
  end

  def self.sprite_changed?(sprite_name, sprite)
    existing_sprite_info = YAML.load(File.read(sprite_info_file(sprite_name)))
    existing_sprite_info[:sprite] != sprite or existing_sprite_info[:timestamps] != timestamps(sprite) 
  rescue
    true
  end

  def self.remember_sprite_info!(sprite_name, sprite)
    File.open(sprite_info_file(sprite_name), 'w') do |file|
      file << {
        :sprite => sprite,
        :timestamps => timestamps(sprite),
      }.to_yaml
    end
  end

  def self.timestamps(sprite)
    result = {}
    sprite[:images].each do |image|
      file_name = image[:file]
      result[file_name] = File.ctime(File.join(Compass.configuration.images_path, file_name))
    end
    result
  end
end
