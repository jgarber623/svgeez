module Svgeez
  module Commands
    class Build < Command
      def self.init_with_program(p)
        p.command(:build) do |c|
          c.description 'Builds an SVG sprite from a folder of SVG icons'
          c.syntax 'build [options]'

          add_build_options(c)

          c.action do |_, options|
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
