module Lemonade
  module SassExtensions
    module Functions
    end
  end
end

require 'rubygems'
require 'compass'
require 'rmagick'
require File.dirname(__FILE__) + '/lemonade/sass_extensions/functions/lemonade'
require File.dirname(__FILE__) + '/lemonade/lemonade'

module Sass::Script::Functions
  include Lemonade::SassExtensions::Functions::Lemonade
end

module Compass
  class Compiler
    alias_method :complile_without_comprass, :compile
    def compile(sass_filename, css_filename)
      complile_without_comprass sass_filename, css_filename
      Lemonade::generate_sprites
    end
  end
end