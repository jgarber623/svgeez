module Svgeez
  class Builder
    SOURCE_IS_DESTINATION_MESSAGE = "Setting `source` and `destination` to the same path isn't allowed!".freeze
    NO_SVGS_IN_SOURCE_MESSAGE = 'No SVGs were found in `source` folder.'.freeze

    def initialize(options = {})
      @options = options
    end

    # rubocop:disable Metrics/AbcSize
    def build
      return Svgeez.logger.error(SOURCE_IS_DESTINATION_MESSAGE) if source_is_destination?
      return Svgeez.logger.warn(NO_SVGS_IN_SOURCE_MESSAGE) if source_is_empty?

      Svgeez.logger.info "Generating sprite at `#{destination.file_path}` from #{source.file_paths.length} SVG#{'s' if source.file_paths.length > 1}..."

      # Make destination folder
      FileUtils.mkdir_p(destination.folder_path)

      # Write the file
      File.open(destination.file_path, 'w') do |f|
        f.write destination_file_contents
      end

      Svgeez.logger.info "Successfully generated sprite at `#{destination.file_path}`."
    end
    # rubocop:enable Metrics/AbcSize

    def destination
      @destination ||= Destination.new(@options)
    end

    def source
      @source ||= Source.new(@options)
    end

    private

    def destination_file_contents
      file_contents = SvgElement.new(source, destination).build
      file_contents = Optimizer.new.optimize(file_contents) if @options['svgo']

      file_contents.insert(4, ' style="position:absolute; width: 0; height: 0;"')
    end

    def source_is_destination?
      /\A#{source.folder_path}/ =~ destination.folder_path
    end

    def source_is_empty?
      source.file_paths.empty?
    end
  end
end
