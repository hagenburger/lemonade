module Sass
  module Plugin
    alias :update_stylesheets_without_lemonade :update_stylesheets
    def update_stylesheets
      Lemonade.generate_sprites if update_stylesheets_without_lemonade
    end
  end
end
