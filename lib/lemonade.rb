require 'chunky_png'
require 'lemonade/sprite_info.rb'

module Lemonade
  @@sprites = {}
  @@sprites_path = nil
  @@images_path = nil

  class << self

    def sprites
      @@sprites
    end

    def sprites_path
      @@sprites_path || images_path
    end

    def sprites_path=(path)
      @@sprites_path = path
    end

    def images_path
      @@images_path || defined?(Compass) ? Compass.configuration.images_path : 'public/images'
    end

    def images_path=(path)
      @@images_path = path
    end

    def reset
      @@sprites = {}
    end

    def generate_sprites
      sprites.each do |sprite_name, sprite|
        sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)

        sprite[:images].each do |image|
          single_image  = ChunkyPNG::Image.from_file(image[:file])
          x = (sprite[:width] - image[:width]) * image[:x].value / 100
          sprite_image.replace single_image, x, image[:y].value
        end

        sprite_image.save File.join(Lemonade.images_path, "#{sprite_name}")
      end
    end

    def extend_sass!
      require 'sass'
      require 'sass/plugin'
      require File.expand_path('../lemonade/sass_functions', __FILE__)
      require File.expand_path('../lemonade/sass_extension', __FILE__)
    end
    
    def extend_compass!
      base_directory  = File.join(File.dirname(__FILE__), '..')
      Compass::Frameworks.register('lemonade', :path => base_directory)
    end

    def sprite_info_file(sprite_name)
      File.join(Compass.configuration.images_path, "#{sprite_name}.sprite_info.yml")
    end

    def sprite_changed?(sprite_name, sprite)
      existing_sprite_info = YAML.load(File.read(sprite_info_file(sprite_name)))
      existing_sprite_info[:sprite] != sprite or existing_sprite_info[:timestamps] != timestamps(sprite)
    rescue
      true
    end

    def remember_sprite_info!(sprite_name, sprite)
      File.open(sprite_info_file(sprite_name), 'w') do |file|
        file << {
          :sprite => sprite,
          :timestamps => timestamps(sprite),
        }.to_yaml
      end
    end

    def timestamps(sprite)
      result = {}
      sprite[:images].each do |image|
        file_name = image[:file]
        result[file_name] = File.ctime(File.join(Compass.configuration.images_path, file_name))
      end
      result
    end

  end

end


if defined?(Compass)
  Lemonade.extend_compass!
end


if defined?(ActiveSupport) and Haml::Util.has?(:public_method, ActiveSupport, :on_load)
  # Rails 3.0
  ActiveSupport.on_load :before_initialize do
    Lemonade.extend_sass!
  end
else
  Lemonade.extend_sass!
end

