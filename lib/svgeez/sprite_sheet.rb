# frozen_string_literal: true

module Svgeez
  # Build an SVG sprite sheet (an +svg+ element) and return the resulting
  # +String+.
  #
  # @api private
  class SpriteSheet
    attr_reader :id, :sprites

    # @param sprites [Array<Svgeez::Sprite, String, #to_s>]
    # @param id [String, #to_s]
    def initialize(*sprites, id: "svgeez")
      @sprites = sprites
      @id = id
    end

    # @return [String]
    def contents
      %(<svg id="#{id}" style="display: none;" xmlns="http://www.w3.org/2000/svg">#{sprites.join}</svg>)
    end

    # @return [String]
    alias_method :to_s, :contents
  end
end
