# frozen_string_literal: true

formatters = SimpleCov::Formatter.from_env(ENV)

if RSpec.configuration.files_to_run.length > 1
  require "simplecov-console"

  formatters << SimpleCov::Formatter::Console
end

SimpleCov.start do
  enable_coverage :branch

  formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
end
