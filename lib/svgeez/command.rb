module Svgeez
  class Command
    class << self
      def subclasses
        @subclasses ||= []
      end

      def inherited(base)
        subclasses << base
        super(base)
      end

      def add_build_options(c)
        c.option 'source', '-s', '--source [DIR]', 'Source directory (defaults to ./)'
        c.option 'destination', '-d', '--destination [DIR]', 'Destination directory (defaults to ./_svgeez)'
        c.option 'svgo', '--with-svgo', 'Optimize source SVGs with SVGO before sprite generation (non-destructive)'
      end
    end
  end
end
