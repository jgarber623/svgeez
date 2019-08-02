require 'bundler/gem_tasks'

require 'reek/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Reek::Rake::Task.new do |task|
  task.fail_on_error = false
  task.source_files  = FileList['**/*.rb'].exclude('vendor/**/*.rb')
end

RSpec::Core::RakeTask.new

RuboCop::RakeTask.new do |task|
  task.fail_on_error = false
end

task default: [:rubocop, :reek, :spec]
