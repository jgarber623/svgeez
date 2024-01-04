# frozen_string_literal: true

module Svgeez
  # Build an SVG sprite (a +<symbol>+ element) and return the resulting
  # +String+. Portions of +data+ is modified to accommodate usage in a sprite
  # sheet based on the supplied +prefix+ value.
  #
  # @api private
  class Sprite
    # @param data [String]
    # @param basename [String]
    # @param prefix [String]
    def initialize(data, basename:, prefix: nil)
      @data = data
      @basename = basename
      @prefix = prefix
    end

    # @return [String]
    def contents
      data.match(%r{^<svg\s*?(?<attributes>.*?)>(?<content>.*?)</svg>}m) do |matches|
        "<symbol #{element_attributes(matches[:attributes]).sort.join(" ")}>" \
          "#{element_contents(matches[:content])}" \
          "</symbol>"
      end
    end

    # @return [String]
    alias_method :to_s, :contents

    private

    attr_reader :basename, :data, :prefix

    # @return [Array<String>]
    def element_attributes(attributes)
      attrs = attributes.scan(/(?:viewBox|xmlns:.+?)=".*?"/m)
      attrs << %(id="#{[prefix, basename].reject(&:blank?).join("-")}")
    end

    # @return [String]
    def element_contents(content)
      content.scan(/\sid="(.+?)"/).flatten.each do |value|
        uuid = SecureRandom.uuid

        content.gsub!(/\s(id|xlink:href)="(#?#{value})"/m, %( \\1="\\2-#{uuid}"))
        content.gsub!(
          /\s(clip-path|fill|filter|marker-end|marker-mid|marker-start|mask|stroke)="url\((##{value})\)"/m,
          %( \\1="url(\\2-#{uuid})")
        )
      end

      content
    end
  end
end
