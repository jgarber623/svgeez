module Svgeez
  module Elements
    class SymbolElement
      def initialize(file_path, file_id)
        @file_path = file_path
        @file_id = file_id
        @uuid = SecureRandom.uuid

        @matches = match_file
      end

      def build
        %(<symbol #{element_attributes.sort.join(' ')}>#{element_contents}</symbol>)
      end

      def defs
        element_defs
      end

      private

      def match_file
        IO.read(@file_path).match(%r{^<svg\s*?(?<attributes>.*?)>(\r\n|\r)?(?<content>.*?)(\r\n|\r)?</svg>}m)
      end

      def element_attributes
        attrs = @matches[:attributes].scan(/(?:viewBox|xmlns:.+?)=".*?"/m)
        attrs << %(id="#{@file_id}-#{File.basename(@file_path, '.svg').gsub(/['"\s]/, '-')}")
      end

      def element_contents
        subbed_content = @matches[:content]
        @matches[:content].scan(/\sid="(.+?)"/).flatten.each do |value|
          subbed_content = parameterize_ids(subbed_content, value)
          subbed_content.gsub!(%r{(\r\n|\r)?<defs>(?<content>.*?)<\/defs>(\r\n|\r)?}m, '')
        end

        subbed_content
      end

      # def element_contents
      #   sub_content = @content
      #   sub_content.scan(/\sid="(.+?)"/).flatten.each do |value|
      #     sub_content.gsub!(/\s(id|xlink:href)="(#?#{value})"/m, %( \\1="\\2-#{@uuid}"))
      #     sub_content.gsub!(/\s(clip-path|fill|filter|marker-end|marker-mid|marker-start|mask|stroke)="url\((##{value})\)"/m, %( \\1="url(\\2-#{@uuid})"))
      #     sub_content.gsub!(%r{(\r\n|\r)?<defs>(?<content>.*?)<\/defs>(\r\n|\r)?}m, '')
      #   end

      #   sub_content
      # end

      def element_defs
        @matches[:content].match(%r{(\r\n|\r)?<defs>(?<content>.*?)</defs>(\r\n|\r)?}m) do |match|
          content = match[:content]
          content.scan(/\sid="(.+?)"/).flatten.map { |value| parameterize_ids(content, value) }
          content
        end
      end

      def parameterize_ids(content, id)
        content.gsub!(/\s(id|xlink:href)="(#?#{id})"/m, %( \\1="\\2-#{@uuid}"))
        content.gsub!(/\s(clip-path|fill|filter|marker-end|marker-mid|marker-start|mask|stroke)="url\((##{id})\)"/m, %( \\1="url(\\2-#{@uuid})"))
        content
      end
    end
  end
end
