module Svgeez
  module Commands
    class Watch < Command
      def self.init_with_program(p)
        p.command(:watch) do |c|
          c.description 'Watches a folder of SVG icons for changes'
          c.syntax 'watch [options]'

          add_build_options(c)

          c.action do |_, options|
            Svgeez::Commands::Build.process(options)
            Svgeez::Commands::Watch.process(options)
          end
        end
      end

      def self.process(options)
        sprite_builder = Svgeez::SpriteBuilder.new(options)

        listener = Listen.to(sprite_builder.source, only: /\.svg\z/) do
          sprite_builder.build
        end

        Svgeez.logger.info "Watching `#{sprite_builder.source}` for changes... Press ctrl-c to stop."

        listener.start
        sleep
      rescue Interrupt
        Svgeez.logger.info 'Quitting svgeez...'
      end
    end
  end
end
