module Svgeez
  module Commands
    class Build < Command
      class << self
        def init_with_program(p)
          p.command(:build) do |c|
            c.description 'Builds an SVG sprite from a folder of SVGs'
            c.syntax 'build [options]'

            add_build_options(c)

            c.action do |_, options|
              Svgeez::Commands::Build.process(options)
            end
          end
        end

        def process(options)
          source = File.expand_path(options['source'] || './')
          destination = File.expand_path(options['destination'] || './_svgeez')

          # Abort if `source` and `destination` are the same path
          if source == destination
            Svgeez.logger.error %{Setting `source` and `destination` to the same path isn't allowed!}
            abort
          end

          source_basename = File.basename(source)

          input_file_paths = Dir.glob(File.join(source, '*.svg'))
          output_file_path = File.join(destination, %{#{source_basename}.svg})

          # Abort if `source` has no SVGs
          if input_file_paths.empty?
            Svgeez.logger.warn %{No SVGs were found in `#{source}`.}
            abort
          end

          Svgeez.logger.info %{Generating sprite at `#{output_file_path}` from #{input_file_paths.length} SVG#{'s' if input_file_paths.length > 1}...}

          # Make destination directory
          FileUtils.mkdir_p(destination)

          # Start building output file content
          output_file_contents = '<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">'

          # Process with SVGO? Is the executable in PATH?
          with_svgo = options['svgo'] && find_executable0('svgo')

          if options['svgo'] && !find_executable0('svgo')
            Svgeez.logger.warn %{Unable to find `svgo` in your PATH. Continuing with standard sprite generation...}
          end

          # Loop over all input files, grabbing their content, and appending to `output_file_contents`
          input_file_paths.each do |file_path|
            file_contents = with_svgo ? `svgo -i #{file_path} -o -` : IO.read(file_path)
            pattern = /^<svg.*?(?<viewbox>viewBox=".*?").*?>(?<content>.*?)<\/svg>$/m

            file_contents.match(pattern) do |matches|
              output_file_contents << %{<symbol fill="currentcolor" id="#{source_basename}-#{File.basename(file_path, '.svg').downcase}" #{matches[:viewbox]}>#{matches[:content]}</symbol>}
            end
          end

          # Close that <svg> element
          output_file_contents << '</svg>'

          # Write the file
          File.open(output_file_path, 'w') do |f|
            f.write output_file_contents
          end

          Svgeez.logger.info %{Successfully generated sprite at `#{output_file_path}`.}
        end
      end
    end
  end
end
