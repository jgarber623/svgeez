# frozen_string_literal: true

require_relative "lib/svgeez/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.0"

  spec.name          = "svgeez"
  spec.version       = Svgeez::VERSION
  spec.authors       = ["Jason Garber"]
  spec.email         = ["jason@sixtwothree.org"]

  spec.summary       = "Automatically generate an SVG sprite from a folder of SVG icons."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jgarber623/svgeez"
  spec.license       = "MIT"

  spec.files         = Dir["exe/**/*", "lib/**/*"].reject { |f| File.directory?(f) }
  spec.files        += %w[LICENSE CHANGELOG.md README.md]
  spec.files        += %w[svgeez.gemspec]

  spec.bindir        = "exe"
  spec.executables   = ["svgeez"]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}"
  }

  spec.add_runtime_dependency "listen", "~> 3.5"
  spec.add_runtime_dependency "mercenary", "~> 0.4.0"
end
