require 'simplecov-console'

formatters = [SimpleCov::Formatter::HTMLFormatter]

# rubocop:disable Style/IfUnlessModifier
if RSpec.configuration.files_to_run.length > 1
  formatters << SimpleCov::Formatter::Console
end
# rubocop:enable Style/IfUnlessModifier

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
end
