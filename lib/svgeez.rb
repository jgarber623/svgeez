require 'fileutils'
require 'listen'
require 'logger'

require 'svgeez/version'
require 'svgeez/command'
require 'svgeez/commands/build'
require 'svgeez/commands/watch'
require 'svgeez/sprite_builder'

module Svgeez
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  logger.formatter = proc { |_, _, _, msg| "#{msg}\n" }
end
