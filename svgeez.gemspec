# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svgeez/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.2.5'

  spec.name          = 'svgeez'
  spec.version       = Svgeez::VERSION
  spec.authors       = ['Jason Garber']
  spec.email         = ['jason@sixtwothree.org']

  spec.summary       = 'Automatically generate an SVG sprite from a folder of SVG icons.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/jgarber623/svgeez'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '~> 0.42.0'

  spec.add_runtime_dependency 'listen', '~> 3.0'
  spec.add_runtime_dependency 'mercenary', '~> 0.3'
end
