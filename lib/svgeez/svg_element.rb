module Svgeez
  class SvgElement
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def build
      %(<svg id="#{@destination.file_id}" xmlns="http://www.w3.org/2000/svg">#{symbol_elements.join}</svg>)
    end

    private

    def symbol_elements
      @source.file_paths.map do |file_path|
        SymbolElement.new(file_path, @destination.file_id).build
      end
    end
  end
end
