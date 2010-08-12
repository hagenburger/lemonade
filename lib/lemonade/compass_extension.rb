module Compass
  class Compiler
    alias_method :compile_without_lemonade, :compile
    def compile(*args)
      compile_without_lemonade *args
      Lemonade::generate_sprites
    end
  end
end
