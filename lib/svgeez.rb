require 'fileutils'
require 'listen'
require 'logger'
require 'mkmf'
require 'securerandom'

require 'svgeez/version'

require 'svgeez/command'
require 'svgeez/commands/build'
require 'svgeez/commands/watch'

require 'svgeez/builder'
require 'svgeez/destination'
require 'svgeez/optimizer'
require 'svgeez/source'
require 'svgeez/svg_element'
require 'svgeez/symbol_element'

module Svgeez
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  logger.formatter = proc { |_, _, _, msg| "#{msg}\n" }
end
