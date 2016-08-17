require 'fileutils'
require 'listen'
require 'logger'

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

  logger.formatter = proc do |_, _, _, msg|
    "#{msg}\n"
  end
end
