module Svgeez
  module Commands
    class Build < Command
      def self.init_with_program(program)
        program.command(:build) do |command|
          command.description 'Builds an SVG sprite from a folder of SVG icons'
          command.syntax 'build [options]'

          add_build_options(command)

          command.action do |_, options|
            Build.process(options)
          end
        end
      end

      def self.process(options)
        Svgeez::Builder.new(options).build
      end
    end
  end
end
