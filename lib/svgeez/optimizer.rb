module Svgeez
  class Optimizer
    SVGO_MINIMUM_VERSION = '1.3.0'.freeze
    SVGO_MINIMUM_VERSION_MESSAGE = "svgeez relies on SVGO #{SVGO_MINIMUM_VERSION} or newer. Continuing with standard sprite generation...".freeze
    SVGO_NOT_INSTALLED = 'Unable to find `svgo` in your PATH. Continuing with standard sprite generation...'.freeze

    def optimize(file_contents)
      raise SVGO_NOT_INSTALLED unless installed?
      raise SVGO_MINIMUM_VERSION_MESSAGE unless supported?

      `cat <<EOF | svgo --disable=cleanupIDs --disable=removeHiddenElems --disable=removeViewBox -i - -o -\n#{file_contents}\nEOF`
    rescue RuntimeError => exception
      logger.warn exception.message
    end

    private

    def installed?
      @installed ||= find_executable0('svgo')
    end

    def logger
      @logger ||= Svgeez.logger
    end

    def supported?
      @supported ||= Gem::Version.new(`svgo -v`.strip) >= Gem::Version.new(SVGO_MINIMUM_VERSION)
    end
  end
end
