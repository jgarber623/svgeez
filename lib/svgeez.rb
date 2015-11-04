require 'fileutils'
require 'listen'
require 'logger'
require 'mkmf'

require 'svgeez/version'
require 'svgeez/command'
require 'svgeez/commands/build'
require 'svgeez/commands/watch'
require 'svgeez/sprite_builder'

module Svgeez
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end

  self.logger.formatter = proc do |severity, datetime, progname, msg|
    %{#{msg}\n}
  end
end
