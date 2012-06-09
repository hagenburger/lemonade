module Sass

  module Tree

    class RootNode < Node

      alias_method :render_without_lemonade, :render
      def render
        if result = render_without_lemonade
          Lemonade.generate_sprites
          result = ERB.new(result).result(binding)
          Lemonade.reset
          return result
        end
      end

    end

  end

end


module Sass

  module Tree

    class ImportNode < RootNode
	  
		alias_method :_perform_without_lemonade, :_perform
		def _perform(environment)
		  # ru: Последний импортированный sass файл.
		  # en: set last imported sass filename
		  Lemonade.last_imported_full_filename = full_filename
		  _perform_without_lemonade environment  
		end
	
    end

  end

end