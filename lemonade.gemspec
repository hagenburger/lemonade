# -*- encoding: utf-8 -*-

require File.expand_path('../lib/lemonade/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'lemonade'
  s.version = Lemonade::Version
  s.date = Time.now.strftime '%Y-%m-%d'

  s.required_rubygems_version = '>= 1.3.6'
  s.authors = ['Nico Hagenburger']
  s.email = 'gems@hagenburger.net'
  s.homepage = 'http://github.com/hagenburger/lemonade'
  s.summary = 'On the fly sprite generator for Sass/Compass'
  s.description = %q{Generates sprites on the fly by using `background: sprite-image("sprites/logo.png")`. No Photoshop, no RMagick, no Rake task, save your time and have a lemonade.}

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options = ['--charset=UTF-8']

  s.files = Dir["lib/**/*"] + Dir["stylesheets/**/*"] + %w(CHANGELOG.md MIT-LICENSE Rakefile README.md)
  s.test_files = Dir['spec/**/*']
  s.require_path = 'lib'

  s.add_runtime_dependency 'haml', '~> 3.0.0'
  s.add_runtime_dependency 'chunky_png', '~> 0.9.0'

  s.add_development_dependency 'rake', '~> 0.8.7'
  s.add_development_dependency 'rspec', '~> 1.3.0'
end

