# frozen_string_literal: true

module Svgeez
  module Elements
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
        id_prefix = @file_id
        id_suffix = File.basename(@file_path, '.svg').gsub(/['"\s]/, '-')
        id_attribute = [id_prefix, id_suffix].reject(&:empty?).join('-')

        attrs << %(id="#{id_attribute}")
      end

      def element_contents(content)
        content.scan(/\sid="(.+?)"/).flatten.each do |value|
          uuid = SecureRandom.uuid

          content.gsub!(/\s(id|xlink:href)="(#?#{value})"/m, %( \\1="\\2-#{uuid}"))
          content.gsub!(/\s(clip-path|fill|filter|marker-end|marker-mid|marker-start|mask|stroke)="url\((##{value})\)"/m, %( \\1="url(\\2-#{uuid})"))
        end

        content
      end
    end
  end
end
