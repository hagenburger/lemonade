# -*- encoding: utf-8 -*-

require File.expand_path('../lib/lemonade/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'lemonade'
  s.version = Lemonade::Version
  s.date = Time.now.strftime '%Y-%m-%d'

  s.authors = ['Nico Hagenburger']
  s.email = 'gems@hagenburger.net'
  s.homepage = 'http://github.com/hagenburger/lemonade'
  s.summary = 'On the fly sprite generator for Sass/Compass'
  s.description = %q{Generates sprites on the fly by using `background: sprite-image("sprites/logo.png")`. No Photoshop, no RMagick, no Rake task, save your time and have a lemonade.}

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options = ['--charset=UTF-8']

  s.files = Dir["lib/**/*"] + %w(CHANGELOG.md MIT-LICENSE README.md)
  s.require_path = 'lib'
end

