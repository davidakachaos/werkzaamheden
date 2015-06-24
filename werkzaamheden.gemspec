# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'werkzaamheden/version'

Gem::Specification.new do |spec|
  spec.name          = "werkzaamheden"
  spec.version       = Werkzaamheden::VERSION
  spec.authors       = ["David Westerink"]
  spec.email         = ["davidakachaos@gmail.com"]

  spec.summary       = %q{Interface to werkzaamheden.nl}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/davidakachaos/werkzaamheden"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'htmlentities'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
