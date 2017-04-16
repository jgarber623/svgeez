module Svgeez
  class Destination
    DEFAULT_DESTINATION_FILE_NAME = 'svgeez.svg'.freeze

    def initialize(options = {})
      @options = options
    end

    def file_id
      @file_id ||= File.basename(file_name, '.svg').tr(' ', '-')
    end

    def file_name
      @file_name ||=
        if destination.end_with?('.svg')
          File.split(destination)[1]
        else
          DEFAULT_DESTINATION_FILE_NAME
        end
    end

    def file_path
      @file_path ||= File.join(folder_path, file_name)
    end

    def folder_path
      @folder_path ||=
        if destination.end_with?('.svg')
          File.split(destination)[0]
        else
          destination
        end
    end

    private

    def destination
      @destination ||= File.expand_path(@options.fetch('destination', "./#{DEFAULT_DESTINATION_FILE_NAME}"))
    end
  end
end
