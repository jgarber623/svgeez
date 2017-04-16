module Svgeez
  class Source
    DEFAULT_INPUT_FOLDER_PATH = './_svgeez'.freeze

    def initialize(options = {})
      @options = options
    end

    def file_paths
      Dir.glob(file_paths_pattern)
    end

    def folder_path
      @folder_path ||= File.expand_path(@options.fetch('source', DEFAULT_INPUT_FOLDER_PATH))
    end

    private

    def file_paths_pattern
      @file_paths_pattern ||= File.join(folder_path, '*.svg')
    end
  end
end
