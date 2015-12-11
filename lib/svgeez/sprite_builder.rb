module Svgeez
  class SpriteBuilder
    def initialize(options)
      @source = File.expand_path(options.fetch('source', './'))
      @destination = File.expand_path(options.fetch('destination', './_svgeez'))
      @with_svgo = options['svgo']
    end

    def build
      unless source_is_destination?
        if source_file_paths.any?
          Svgeez.logger.info %{Generating sprite at `#{destination_file_path}` from #{source_file_paths.length} SVG#{'s' if source_file_paths.length > 1}...}

          # Make destination directory
          FileUtils.mkdir_p(@destination)

          # Notify if SVGO requested but not found
          if @with_svgo && !svgo_installed?
            Svgeez.logger.warn %{Unable to find `svgo` in your PATH. Continuing with standard sprite generation...}
          end

          # Write the file
          File.open(destination_file_path, 'w') do |f|
            f.write build_destination_file_contents
          end

          Svgeez.logger.info %{Successfully generated sprite at `#{destination_file_path}`.}
        else
          Svgeez.logger.warn %{No SVGs were found in `#{@source}`.}
        end
      else
        Svgeez.logger.error %{Setting `source` and `destination` to the same path isn't allowed!}
      end
    end

    def build_destination_file_contents
      %{<svg id="#{source_basename}" style="display: none;" version="1.1">}.tap do |destination_file_contents|
        # Loop over all source files, grabbing their content, and appending to `destination_file_contents`
        source_file_paths.each do |file_path|
          file_contents = use_svgo? ? `svgo -i #{file_path} -o -` : IO.read(file_path)
          pattern = /^<svg.*?(?<viewbox>viewBox=".*?").*?>(?<content>.*?)<\/svg>/m

          file_contents.match(pattern) do |matches|
            destination_file_contents << %{<symbol id="#{source_basename}-#{File.basename(file_path, '.svg').downcase}" #{matches[:viewbox]}>#{matches[:content]}</symbol>}
          end
        end

        destination_file_contents << '</svg>'
      end
    end

    def destination_file_path
      File.join(@destination, %{#{source_basename}.svg})
    end

    def source_basename
      @source_basename ||= File.basename(@source)
    end

    def source_file_paths
      Dir.glob(File.join(@source, '*.svg'))
    end

    def source_is_destination?
      @source == @destination
    end

    def svgo_installed?
      @svgo_installed ||= find_executable0('svgo')
    end

    def use_svgo?
      @use_svgo ||= @with_svgo && svgo_installed?
    end
  end
end
