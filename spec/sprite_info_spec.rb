require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sass::Script::SpriteInfo do

  before :each do
    Compass.configuration.http_images_path = ''
  end

  def sprite_info(*args)
    Sass::Script::SpriteInfo.new(*args).to_s
  end

  ##

  it "should output the position" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']) }
    x = Sass::Script::Number.new(10, ['px'])
    sprite_info(:position, sprite, sprite_item, x).should == "10px -20px"
  end

  it "should output the position with y shift" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']) }
    x = Sass::Script::Number.new(10, ['px'])
    y_shift = Sass::Script::Number.new(3, ['px'])
    sprite_info(:position, sprite, sprite_item, x, y_shift).should == "10px -17px"
  end

  it "should output the position with percentage" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']) }
    x = Sass::Script::Number.new(100, ['%'])
    sprite_info(:position, sprite, sprite_item, x).should == "100% -20px"
  end

  it "should output the url" do
    sprite = { :file => "sprites.png" }
    sprite_item = { }
    sprite_info(:url, sprite, sprite_item).should == "url('/sprites.png')"
  end

  it "should output the url with compass path" do
    sprite = { :file => "sprites.png" }
    sprite_item = { }
    Compass.configuration.http_images_path = '/louvre'
    sprite_info(:url, sprite, sprite_item).should == "url('/louvre/sprites.png')"
  end

end