module Svgeez
  module Elements
    class SymbolElement
      def initialize(file_path, file_id)
        @file_path = file_path
        @file_id = file_id
        @uuid = SecureRandom.uuid
        read
      end

      def build
        %(<symbol #{element_attributes.sort.join(' ')}>#{element_contents}</symbol>)
      end

      def defs
        element_defs
      end

      private

      def read
        IO.read(@file_path).match(%r{^<svg\s*?(?<attributes>.*?)>(?<content>.*?)</svg>}m) do |matches|
          @attributes = matches[:attributes]
          @content = matches[:content]
        end
      end

      def element_attributes
        attrs = @attributes.scan(/(?:viewBox|xmlns:.+?)=".*?"/m)
        attrs << %(id="#{@file_id}-#{File.basename(@file_path, '.svg').gsub(/['"\s]/, '-')}")
      end

      def element_contents
        sub_content = @content
        sub_content.scan(/\sid="(.+?)"/).flatten.each do |value|

          sub_content.gsub!(/\s(id|xlink:href)="(#?#{value})"/m, %( \\1="\\2-#{@uuid}"))
          sub_content.gsub!(/\s(clip-path|fill|filter|marker-end|marker-mid|marker-start|mask|stroke)="url\((##{value})\)"/m, %( \\1="url(\\2-#{@uuid})"))
          sub_content.gsub!(/<defs>(?<content>.*?)<\/defs>/, "")
        end

        sub_content
      end

      def element_defs
        @content.match(%r{<defs>(?<content>.*?)</defs>}m) do |match|
          content = match[:content]
          content.scan(/\sid="(.+?)"/).flatten.each do |value|

            content.gsub!(/\s(id|xlink:href)="(#?#{value})"/m, %( \\1="\\2-#{@uuid}"))
          end

          content
        end
      end
    end
  end
end
