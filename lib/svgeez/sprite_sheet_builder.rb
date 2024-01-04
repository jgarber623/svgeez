# frozen_string_literal: true

module Svgeez
  # Build an SVG sprite sheet from a folder of SVG files and write the results
  # to a file.
  class SpriteSheetBuilder
    attr_reader :input_path, :output_path, :prefix

    # @param input_path [String, Pathname, #to_s]
    # @param output_path [String, Pathanme, #to_s]
    # @param prefix [String, #to_s]
    def initialize(input_path = "./_svgeez", output_path = "./svgeez.svg", prefix: nil)
      @input_path = input_path
      @output_path = output_path
      @prefix = prefix.presence || sprite_sheet_id
    end

    # @return [Integer]
    def build_sprite_sheet
      dirname = File.dirname(output_file_path)

      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

      File.write(output_file_path, sprite_sheet.to_s)
    end

    # @return [Array<Svgeez::Sprite>]
    def sprites
      input_file_paths.map do |input_file_path|
        basename = File.basename(input_file_path, ".svg").gsub(/['"\s]/, "-")

        Sprite.new(File.read(input_file_path), basename: basename, prefix: prefix)
      end
    end

    # @return [Svgeez::SpriteSheet]
    def sprite_sheet
      SpriteSheet.new(sprites, id: sprite_sheet_id)
    end

    private

    # @return [Array<String>]
    def input_file_paths
      Dir[File.expand_path(File.join(input_path, "*.svg"))]
    end

    # @return [String]
    def output_file_path
      @output_file_path ||=
        File.expand_path(output_path.end_with?(".svg") ? output_path : File.join(output_path, "svgeez.svg"))
    end

    def sprite_sheet_id
      @sprite_sheet_id ||= File.basename(output_file_path, ".svg").tr(" ", "-")
    end
  end
end
