module Svgeez
  class SymbolElement
    def initialize(file_path, file_id)
      @file_path = file_path
      @file_id = file_id
    end

    def build
      IO.read(@file_path).match(%r{^<svg\s*?(?<attributes>.*?)>(?<content>.*?)</svg>}m) do |matches|
        %(<symbol #{element_attributes(matches[:attributes]).sort.join(' ')}>#{element_contents(matches[:content])}</symbol>)
      end
    end

    private

    def element_attributes(attributes)
      attrs = attributes.scan(/(?:viewBox|xmlns:.+?)=".*?"/m)

      attrs << %(id="#{@file_id}-#{File.basename(@file_path, '.svg').gsub(/['"\s]/, '-')}")
    end

    def element_contents(content)
      content.scan(/\sid="(.+?)"/).flatten.each do |value|
        content.gsub!(/\s(id|xlink:href)="(#?#{value})"/m, %( \\1="\\2-#{SecureRandom.uuid}"))
      end

      content
    end
  end
end
