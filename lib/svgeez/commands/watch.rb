# frozen_string_literal: true

module Svgeez
  module Commands
    class Watch < Command
      class << self
        def process(options)
          builder = Svgeez::Builder.new(options)
          folder_path = builder.source.folder_path

          Svgeez.logger.info "Watching `#{folder_path}` for changes... Press ctrl-c to stop."

          Listen.to(folder_path, only: /\.svg\z/) { builder.build }.start
          sleep
        rescue Interrupt
          Svgeez.logger.info "Quitting svgeez..."
        end

        private

        def command_action(options)
          Build.process(options)
          Watch.process(options)
        end

        def command_description
          "Watches a folder of SVG icons for changes"
        end

        def command_syntax
          "watch [options]"
        end
      end
    end
  end
end
