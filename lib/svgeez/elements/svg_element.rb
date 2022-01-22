# frozen_string_literal: true

module Svgeez
  module Elements
    class SvgElement
      def initialize(source, destination, prefix)
        @source = source
        @destination = destination
        @prefix = prefix
      end

      def build
        %(<svg id="#{@destination.file_id}" xmlns="http://www.w3.org/2000/svg">#{symbol_elements.join}</svg>)
      end

      private

      def symbol_elements
        @source.file_paths.map do |file_path|
          SymbolElement.new(file_path, @prefix).build
        end
      end
    end
  end
end
