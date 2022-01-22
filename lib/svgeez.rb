# frozen_string_literal: true

require 'fileutils'
require 'logger'
require 'mkmf'
require 'securerandom'

require 'listen'
require 'mercenary'

require_relative 'svgeez/version'

require_relative 'svgeez/command'
require_relative 'svgeez/commands/build'
require_relative 'svgeez/commands/watch'

require_relative 'svgeez/elements/svg_element'
require_relative 'svgeez/elements/symbol_element'

require_relative 'svgeez/builder'
require_relative 'svgeez/destination'
require_relative 'svgeez/optimizer'
require_relative 'svgeez/source'

module Svgeez
  def self.logger
    @logger ||= Logger.new($stdout)
  end

  logger.formatter = proc { |_, _, _, msg| "#{msg}\n" }
end
