module Svgeez
  class SvgElement
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def build
      %(<svg id="#{@destination.file_id}" version="1.1" xmlns="http://www.w3.org/2000/svg">#{element_contents}</svg>)
    end

    private

    def element_contents
      @source.file_paths.map { |file_path| SymbolElement.new(file_path, @destination.file_id).build }.join
    end
  end
end
