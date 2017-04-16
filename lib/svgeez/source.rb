module Svgeez
  class Source
    DEFAULT_INPUT_FOLDER_PATH = './_svgeez'.freeze

    def initialize(options = {})
      @options = options
    end

    def file_paths
      @file_paths ||= Dir.glob(File.join(folder_path, '*.svg'))
    end

    def folder_path
      @folder_path ||= File.expand_path(@options.fetch('source', DEFAULT_INPUT_FOLDER_PATH))
    end
  end
end
