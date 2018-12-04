module Svgeez
  class Source
    DEFAULT_INPUT_FOLDER_PATH = './_svgeez'.freeze

    attr_reader :folder_path

    def initialize(options = {})
      @folder_path = File.expand_path(options.fetch('source', DEFAULT_INPUT_FOLDER_PATH))
    end

    def file_paths
      Dir.glob(file_paths_pattern)
    end

    private

    def file_paths_pattern
      @file_paths_pattern ||= File.join(folder_path, '*.svg')
    end
  end
end
