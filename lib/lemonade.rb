require 'chunky_png'

module Lemonade
  class << self
    attr_accessor :sprites

    def generate_sprites
      sprites.each do |sprite_name, sprite|
        sprite_image = ChunkyPNG::Image.new(sprite[:width], sprite[:height], ChunkyPNG::Color::TRANSPARENT)

        sprite[:images].each do |image|
          file = File.join(Compass.configuration.images_path, image[:file])
          single_image  = ChunkyPNG::Image.from_file(file)
          x = (sprite[:width] - image[:width]) * image[:x]
          sprite_image.replace single_image, x, image[:y]
        end

        file = File.join(Compass.configuration.images_path, "#{ sprite_name }.png")
        sprite_image.save file
      end

      # sprites.clear
    end

    def extend_sass!
      require 'sass'
      require 'sass/plugin'
      require File.expand_path('../lemonade/sass_functions', __FILE__)
      require File.expand_path('../lemonade/sass_extension', __FILE__)
    end
  end

  self.sprites = {}
end

# Activate compass integration
require File.expand_path('../lemonade/compass_extension', __FILE__) # if defined?(Compass)

# Rails 3.0.0.beta.2+
if defined?(ActiveSupport) && Haml::Util.has?(:public_method, ActiveSupport, :on_load)
  # require 'haml/template/options'
  # require 'sass/plugin/configuration'
  ActiveSupport.on_load(:before_initialize) { Lemonade.extend_sass! }
else
  Lemonade.extend_sass!
end

