require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "lemonade.scss" do

  before :each do
    Lemonade.reset
    FileUtils.cp_r File.dirname(__FILE__) + '/images', IMAGES_TMP_PATH
  end

  after :each do
    FileUtils.rm_r IMAGES_TMP_PATH
  end

  def evaluate(*values)
    sass = '@import "lemonade"' + "\n" +
           "div" + values.map{ |value| "\n #{value}" }.join
    path = File.expand_path(File.dirname(__FILE__) + '/../stylesheets')
    css = Sass::Engine.new(sass, :syntax => :sass, :load_paths => [path]).render
    # find rendered CSS values strip selectors hitespace
    css = css.gsub(/div \{\s*(.+?);\s*\}\s*/m, '\\1')
    css = css.first if css.length == 1
    return css
  end
  
  it "should have `sprite_image` mixin" do
    evaluate('+sprite-image("sprites/30x30.png")').should == "background: url('/sprites.png')"
  end
  
end
