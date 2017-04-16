module Svgeez
  class SvgElement
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def build
      %(<svg #{build_attributes}>#{collect_source_files.join}</svg>)
    end

    private

    def build_attributes
      %(id="#{@destination.file_id}" version="1.1" xmlns="http://www.w3.org/2000/svg")
    end

    def collect_source_files
      @source.file_paths.collect do |file_path|
        SymbolElement.new(file_path, @destination.file_id).build
      end
    end
  end
end
