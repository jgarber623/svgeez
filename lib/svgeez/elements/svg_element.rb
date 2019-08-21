module Svgeez
  module Elements
    class SvgElement
      def initialize(source, destination)
        @source = source
        @destination = destination
        @symbol_elements = @source.file_paths.map do |file_path|
          SymbolElement.new(file_path, @destination.file_id)
        end
      end

      def build
        %(<svg id="#{@destination.file_id}" xmlns="http://www.w3.org/2000/svg">#{defs_element}#{symbols}</svg>)
      end

      private

      def symbols
        @symbol_elements.map(&:build).join
      end

      def defs_element
        DefsElement.new(@symbol_elements).build
      end
    end
  end
end
