require 'simplecov'
require 'svgeez'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

RSpec.configure do |rspec|
  rspec.expect_with :rspec do |c|
    c.max_formatted_output_length = 1000 # n is number of lines, or nil for no truncation.
  end
end
