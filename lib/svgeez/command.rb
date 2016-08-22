module Svgeez
  class Command
    def self.subclasses
      @subclasses ||= []
    end

    def self.inherited(base)
      subclasses << base
      super(base)
    end

    def self.add_build_options(c)
      c.option 'source', '-s', '--source [FOLDER]', 'Source folder (defaults to ./)'
      c.option 'destination', '-d', '--destination [OUTPUT]', 'Destination file or folder (defaults to ./_svgeez/svgeez.svg)'
      c.option 'svgo', '--with-svgo', 'Optimize source SVGs with SVGO before sprite generation (non-destructive)'
    end
  end
end
