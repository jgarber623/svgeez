require 'codeclimate-test-reporter'
require 'svgeez'

CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
