require 'sass/script/literal'

module Sass::Script

  class SpriteInfo < Literal
    attr_reader :sprite
    attr_reader :sprite_item
    attr_reader :type

    def initialize(type, sprite, sprite_item = nil, position_x = nil, position_y_shift = nil)
      super(nil)
      @type = type
      @sprite = sprite
      @sprite_item = sprite_item
      @position_x = position_x
      @position_y_shift = position_y_shift
    end

    def to_s(opts = {})
      case @type
      when :position
        position
      when :url
        url
      when :both
        pos = position
        if pos == '0 0'
          url
        else
          "#{url} #{pos}"
        end
      end
    end

    def to_sass
      to_s
    end

  private

    def position
      x = @position_x || 0
      y = @sprite_item[:y].times(Sass::Script::Number.new(-1))
      y = y.plus(@position_y_shift) if @position_y_shift
      "#{x.inspect} #{y.inspect}"
    end

    def url
      if defined?(Compass)
        compass = Class.new.extend(Compass::SassExtensions::Functions::Urls)
        compass.image_url(Sass::Script::String.new(@sprite[:file])).to_s
      else
        "url('/#{@sprite[:file]}')"
      end
    end

  end

end
