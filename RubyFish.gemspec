# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'RubyFish/version'

Gem::Specification.new do |spec|
  spec.name          = "RubyFish"
  spec.version       = RubyFish::VERSION
  spec.authors       = ["zvezdi"]
  spec.email         = ["zvezdi.dim@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  end

  spec.summary       = %q{Hungry fish game.}
  spec.description   = %q{A little game where the goal is to eat the other fish and become the biggest fish in the sea.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "gosu", "~> 0.8"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
end
