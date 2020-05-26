require 'bundler/setup'
require 'simplecov'
require 'svgeez'

# $LOAD_PATH.unshift File.expand_path('../lib', __dir__)

RSpec.configure(&:disable_monkey_patching!)
