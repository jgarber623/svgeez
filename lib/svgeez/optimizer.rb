# frozen_string_literal: true

module Svgeez
  class Optimizer
    SVGO_VERSION = '1.3.2'
    SVGO_VERSION_MESSAGE = "svgeez relies on SVGO #{SVGO_VERSION}. Continuing with standard sprite generation..."
    SVGO_NOT_INSTALLED = 'Unable to find `svgo` in your PATH. Continuing with standard sprite generation...'

    def optimize(file_contents)
      raise SVGO_NOT_INSTALLED unless installed?
      raise SVGO_VERSION_MESSAGE unless supported?

      `cat <<EOF | svgo --disable=cleanupIDs --disable=removeHiddenElems --disable=removeViewBox -i - -o -\n#{file_contents}\nEOF`
    rescue RuntimeError => e
      logger.warn e.message
    end

    private

    def installed?
      @installed ||= find_executable0('svgo')
    end

    def logger
      @logger ||= Svgeez.logger
    end

    def supported?
      @supported ||= `svgo -v`.strip == SVGO_VERSION
    end
  end
end
