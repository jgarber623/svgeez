# frozen_string_literal: true

require "securerandom"

require_relative "svgeez/version"

require_relative "core_ext/object/blank"

require_relative "svgeez/sprite"
require_relative "svgeez/sprite_sheet"
require_relative "svgeez/sprite_sheet_builder"

module Svgeez
  # @param (see Svgeez::SpriteSheetBuilder#initialize)
  # @return (see Svgeez::SpriteSheetBuilder#initialize)
  def self.build_sprite_sheet(...)
    Svgeez::SpriteSheetBuilder.new(...).build_sprite_sheet
  end
end
