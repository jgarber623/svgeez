module Svgeez
  class SpriteBuilder
    def initialize(options = {})
      @options = options
    end

    def build
      if source_is_destination?
        Svgeez.logger.error "Setting `source` and `destination` to the same path isn't allowed!"
      elsif source_file_paths.empty?
        Svgeez.logger.warn "No SVGs were found in `#{source}`."
      else
        Svgeez.logger.info "Generating sprite at `#{destination_file_path}` from #{source_file_paths.length} SVG#{'s' if source_file_paths.length > 1}..."

        # Make destination folder
        FileUtils.mkdir_p(destination_folder_path)

        # Notify if SVGO requested but not found
        if svgo_use? && !svgo_installed?
          Svgeez.logger.warn 'Unable to find `svgo` in your PATH. Continuing with standard sprite generation...'
        end

        # Write the file
        File.open(destination_file_path, 'w') do |f|
          f.write build_destination_file_contents
        end

        Svgeez.logger.info "Successfully generated sprite at `#{destination_file_path}`."
      end
    end

    def destination
      @destination ||= File.expand_path(@options.fetch('destination', './svgeez.svg'))
    end

    def source
      @source ||= File.expand_path(@options.fetch('source', './_svgeez'))
    end

    private

    def build_destination_file_contents
      destination_file_contents = "<svg>#{collect_source_files_contents.join}</svg>"

      if svgo_use? && svgo_installed?
        destination_file_contents = `cat <<EOF | svgo --disable=cleanupIDs -i - -o -\n#{destination_file_contents}\nEOF`
      end

      destination_file_contents.insert(4, %( id="#{destination_file_id}" style="display: none;" version="1.1"))
    end

    def collect_source_files_contents
      source_file_paths.collect do |file_path|
        IO.read(file_path).match(%r{^<svg.*?(?<viewbox>viewBox=".*?").*?>(?<content>.*?)</svg>}m) do |matches|
          %(<symbol id="#{destination_file_id}-#{File.basename(file_path, '.svg').gsub(/['"\s]/, '-')}" #{matches[:viewbox]}>#{matches[:content]}</symbol>)
        end
      end
    end

    def destination_file_id
      @destination_file_id ||= File.basename(destination_file_name, '.svg').tr(' ', '-')
    end

    def destination_file_name
      if destination.end_with?('.svg')
        File.split(destination)[1]
      else
        'svgeez.svg'
      end
    end

    def destination_file_path
      @destination_file_path ||= File.join(destination_folder_path, destination_file_name)
    end

    def destination_folder_path
      if destination.end_with?('.svg')
        File.split(destination)[0]
      else
        destination
      end
    end

    def source_file_paths
      @source_file_paths ||= Dir.glob(File.join(source, '*.svg'))
    end

    def source_is_destination?
      /\A#{source}/ =~ destination_folder_path
    end

    def svgo_use?
      @svgo_use ||= @options['svgo']
    end

    def svgo_installed?
      @svgo_installed ||= find_executable0('svgo')
    end
  end
end
