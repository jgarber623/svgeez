# frozen_string_literal: true

require 'fileutils'
require 'logger'
require 'mkmf'
require 'securerandom'

require 'listen'
require 'mercenary'

require 'svgeez/version'

require 'svgeez/command'
require 'svgeez/commands/build'
require 'svgeez/commands/watch'

require 'svgeez/elements/svg_element'
require 'svgeez/elements/symbol_element'

require 'svgeez/builder'
require 'svgeez/destination'
require 'svgeez/optimizer'
require 'svgeez/source'

module Svgeez
  def self.logger
    @logger ||= Logger.new($stdout)
  end

  logger.formatter = proc { |_, _, _, msg| "#{msg}\n" }
end
