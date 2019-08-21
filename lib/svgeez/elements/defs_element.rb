module Svgeez
  module Elements
    class DefsElement
      def initialize(symbol_elements)
        @symbol_elements = symbol_elements
      end

      def build
        %(<defs>#{@symbol_elements.map(&:defs).join}</defs>)
      end
    end
  end
end
