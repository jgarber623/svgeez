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

  spec.files         = Dir["lib/**/*"].reject { |f| File.directory?(f) }
  spec.files        += ["LICENSE", "CHANGELOG.md", "README.md"]
  spec.files        += ["svgeez.gemspec"]

  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}"
  }
end
