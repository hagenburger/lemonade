module Sass
  module Plugin
    alias :update_stylesheets_without_lemonade :update_stylesheets
    def update_stylesheets
      Lemonade.generate_sprites if update_stylesheets_without_lemonade
    end
  end
  class Engine
    alias_method :render_without_lemonade, :render
    def render
      if result = render_without_lemonade
        Lemonade::generate_sprites
        result
      end
    end
    alias_method :to_css, :render
  end
end
