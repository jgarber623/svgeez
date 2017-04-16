module Svgeez
  class SvgElement
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def build
      %(<svg id="#{@destination.file_id}" version="1.1" xmlns="http://www.w3.org/2000/svg">#{source_files.join}</svg>)
    end

    private

    def source_files
      @source.file_paths.collect do |file_path|
        SymbolElement.new(file_path, @destination.file_id).build
      end
    end
  end
end
