# frozen_string_literal: true

module Svgeez
  module Commands
    class Build < Command
      class << self
        def process(options)
          Svgeez::Builder.new(options).build
        end

        private

        def command_action(options)
          Build.process(options)
        end

        def command_description
          'Builds an SVG sprite from a folder of SVG icons'
        end

        def command_syntax
          'build [options]'
        end
      end
    end
  end
end
