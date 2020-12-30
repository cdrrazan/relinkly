# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rebrandly/version'

Gem::Specification.new do |spec|
  spec.name          = "branded_links"
  spec.version       = Rebrandly::VERSION
  spec.authors       = ["Rajan Bhattarai"]
  spec.email         = ["hey@rajanbhattarai.com"]

  spec.summary       = "A Ruby wrapper for the Rebrandly API "
  spec.description   = "Easily create branded short links in your ruby apps using Rebrandly."
  spec.homepage      = "https://github.com/cdrrazan/relinkly"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.3"
  spec.add_development_dependency "rake", "~> 13.0.3"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_dependency 'httparty', '~> 0.18.1'
end
