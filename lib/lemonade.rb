require 'chunky_png'

module Lemonade
  @@sprites, @@sprites_path, @@images_path = {}, nil, nil

  class << self
    def sprites
      @@sprites
    end

    def sprites_path
      @@sprites_path || images_path
    end

    def sprites_dir=(path)
      @@sprites_path = path
    end

    def images_path
      @@images_path || defined?(Compass) ? Compass.configuration.images_path : 'public/images'
    end

    def images_dir=(path)
      @@images_path = path
    end

    def generate_sprites
      sprites.each do |sprite_name, sprite|
        sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)

        sprite[:images].each do |image|
          single_image  = ChunkyPNG::Image.from_file(image[:file])
          x = (sprite[:width] - image[:width]) * image[:x]
          sprite_image.replace single_image, x, image[:y]
        end

        sprite_image.save File.join(Lemonade.images_path, "#{ sprite_name }.png")
      end

      # sprites.clear
    end

    def extend_sass!
      require 'sass'
      require 'sass/plugin'
      require File.expand_path('../lemonade/sass_functions', __FILE__)
      require File.expand_path('../lemonade/sass_extension', __FILE__)
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
  require File.expand_path('../lemonade/compass_extension', __FILE__)
  base_directory  = File.join(File.dirname(__FILE__), '..')
  stylesheets_dir = File.join(base_directory, 'stylesheets')
  Compass::Frameworks.register('lemonade', :path => base_directory, )
end

# Rails 3.0.0.beta.2+
if defined?(ActiveSupport) && Haml::Util.has?(:public_method, ActiveSupport, :on_load)
  # require 'haml/template/options'
  # require 'sass/plugin/configuration'
  ActiveSupport.on_load(:before_initialize) { Lemonade.extend_sass! }
else
  Lemonade.extend_sass!
end

