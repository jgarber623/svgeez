module Svgeez
  module Commands
    class Watch < Command
      class << self
        def init_with_program(p)
          p.command(:watch) do |c|
            c.description 'Watches a folder of SVGs for changes'
            c.syntax 'watch [options]'

            add_build_options(c)

            c.action do |_, options|
              Svgeez::Commands::Build.process(options)
              Svgeez::Commands::Watch.process(options)
            end
          end
        end

        def process(options)
          Svgeez.logger.info %{Watching `#{File.expand_path(options['source'])}` for changes... Press ctrl-c to stop.}

          listener = Listen.to(options['source'], only: /\.svg$/) do |modified, added, removed|
            Svgeez::Commands::Build.process(options)
          end

          listener.start
          sleep
        rescue Interrupt => e
        end
      end
    end
  end
end
