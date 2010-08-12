require 'rubygems'
require 'bundler'
Bundler.setup

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end

  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end

  task :default => :spec
rescue LoadError
  puts "Rspec (or a dependency) is not available. Try running bundler install"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  require File.expand_path('../lib/lemonade/version', __FILE__)
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lemonade #{Lemonade::Version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
