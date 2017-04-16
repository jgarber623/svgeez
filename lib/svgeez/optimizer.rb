module Svgeez
  class Optimizer
    SVGO_NOT_INSTALLED = 'Unable to find `svgo` in your PATH. Continuing with standard sprite generation...'.freeze

    def optimize(file_contents)
      return Svgeez.logger.warn(SVGO_NOT_INSTALLED) unless installed?

      `cat <<EOF | svgo --disable=cleanupIDs -i - -o -\n#{file_contents}\nEOF`
    end

    private

    def installed?
      @installed ||= find_executable0('svgo')
    end
  end
end
