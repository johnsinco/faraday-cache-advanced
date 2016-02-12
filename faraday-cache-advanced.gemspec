# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday/cache-advanced/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday-cache-advanced"
  spec.version       = Faraday::CacheAdvanced::VERSION
  spec.authors       = ["John Stewart"]
  spec.email         = ["johnsinco@icloud.com"]
  spec.summary       = %q{Simple caching middleware to cache ALL Requests including POST requests in faraday}
  spec.description   = %q{Sometimes you gotta cache POST requests.  This gem gives you a Faraday middleware to cache POST requests.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"

  spec.add_development_dependency "rspec"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
