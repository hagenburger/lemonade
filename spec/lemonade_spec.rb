require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Lemonade::SassExtensions::Functions::Lemonade do
  before :each do
    @sass = Sass::Environment.new
    FileUtils.cp_r File.dirname(__FILE__) + '/images', IMAGES_TMP_PATH
  end
  
  after :each do
    FileUtils.rm_r IMAGES_TMP_PATH
    $lemonade_sprites = nil
  end
  
  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(@sass).to_s
  end
  
  it "should return the sprite file name" do
    evaluate('sprite-image("sprites/test-1.png")').should == "url('/sprites.png')"
  end
  
  it "should work in folders with dashes and underscores" do
    evaluate('sprite-image("other_images/more-images/sprites/test-2.png")').should ==
      "url('/other_images/more-images/sprites.png')"
  end
  
  it "should not work without any folder" do
    lambda { evaluate('sprite-image("test.png")') }.should raise_exception(Sass::SyntaxError)
  end
  
  it "should set the background position" do
    evaluate('sprite-image("sprites/test-1.png")').should == "url('/sprites.png')"
    evaluate('sprite-image("sprites/test-2.png")').should == "url('/sprites.png') 0 -30px"
    Lemonade::generate_sprites
    File.exists?(IMAGES_TMP_PATH + '/sprites.png').should be_true
  end
  
  it "should use the X position" do
    evaluate('sprite-image("sprites/test-1.png", 5px, 0)').should == "url('/sprites.png') 5px 0"
  end
  
end