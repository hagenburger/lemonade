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
      @@images_path || (defined?(Compass) ? Compass.configuration.images_path : 'public/images')
    end

    def images_path=(path)
      @@images_path = path
    end

    def reset
      @@sprites = {}
    end

    def generate_sprites
      sprites.each do |sprite_name, sprite|
        calculate_sprite sprite
        if sprite_changed?(sprite_name, sprite)
          generate_sprite_image sprite
          remember_sprite_info! sprite_name, sprite
        end
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
  
  private

    def sprite_info_file(sprite_name)
      File.join(Lemonade.images_path, "#{sprite_name}.sprite_info.yml")
    end

    def timestamps(sprite)
      result = {}
      sprite[:images].each do |image|
        file_name = image[:file]
        result[file_name] = File.ctime(file_name)
      end
      result
    end
    
    def calculate_sprite(sprite)
      width, margin_bottom, y = 0, 0, 0
      sprite[:images].each do |sprite_item|
        if sprite_item[:index] == 0
          margin_top = 0
        elsif sprite_item[:margin_top] > margin_bottom
          margin_top = sprite_item[:margin_top]
        else
          margin_top = margin_bottom
        end
        y += margin_top
        sprite_item[:y] = Sass::Script::Number.new(y, ['px'])
        y += sprite_item[:height]
        width = sprite_item[:width] if sprite_item[:width] > width
        margin_bottom = sprite_item[:margin_bottom]
      end
      sprite[:height] = y
      sprite[:width] = width
    end

    def generate_sprite_image(sprite)
      sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)
      sprite[:images].each do |sprite_item|
        sprite_item_image  = ChunkyPNG::Image.from_file(sprite_item[:file])
        x = (sprite[:width] - sprite_item[:width]) * (sprite_item[:x].value / 100)
        y = sprite_item[:y].value

        if sprite_item[:repeat]
          copies = (sprite[:width]/sprite_item[:width]).to_i
        else
          copies = 1
        end

        copies.times do |i|
          sprite_image.replace sprite_item_image, x + i*sprite_item[:width], y
        end
      end
      sprite_image.save File.join(Lemonade.images_path, sprite[:file])
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

