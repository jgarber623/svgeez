module Svgeez
  class Builder
    SOURCE_IS_DESTINATION_MESSAGE = "Setting `source` and `destination` to the same path isn't allowed!".freeze
    SOURCE_DOES_NOT_EXIST = 'Provided `source` folder does not exist.'.freeze
    NO_SVGS_IN_SOURCE_MESSAGE = 'No SVGs were found in `source` folder.'.freeze

    attr_reader :source, :destination

    def initialize(options = {})
      @source = Source.new(options)
      @destination = Destination.new(options)
      @svgo = options.fetch('svgo', false)

      raise SOURCE_IS_DESTINATION_MESSAGE if source_is_destination?
      raise SOURCE_DOES_NOT_EXIST unless source_exists?
    rescue RuntimeError => exception
      logger.error exception.message
      exit
    end

    # rubocop:disable Metrics/AbcSize
    def build
      raise NO_SVGS_IN_SOURCE_MESSAGE if source_is_empty?

      logger.info "Generating sprite at `#{destination_file_path}` from #{source_files_count} SVG#{'s' if source_files_count > 1}..."

      # Make destination folder
      FileUtils.mkdir_p(destination.folder_path)

      # Write the file
      File.open(destination_file_path, 'w') do |file|
        file.write destination_file_contents
      end

      logger.info "Successfully generated sprite at `#{destination_file_path}`."
    rescue RuntimeError => exception
      logger.warn exception.message
    end
    # rubocop:enable Metrics/AbcSize

    private

    def destination_file_contents
      file_contents = Elements::SvgElement.new(source, destination).build
      file_contents = Optimizer.new.optimize(file_contents) if @svgo

      file_contents.insert(4, ' style="display: none;"')
    end

    def destination_file_path
      @destination_file_path ||= destination.file_path
    end

    def logger
      @logger ||= Svgeez.logger
    end

    def source_exists?
      File.directory?(source.folder_path)
    end

    def source_files_count
      source.file_paths.length
    end

    def source_is_destination?
      /\A#{source.folder_path}/ =~ destination.folder_path
    end

    def source_is_empty?
      source.file_paths.empty?
    end
  end
end
