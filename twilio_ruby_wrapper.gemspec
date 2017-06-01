# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twilio_ruby_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "twilio_ruby_wrapper"
  spec.version       = TwilioRubyWrapper::VERSION
  spec.authors       = ["FUNABARA Masao"]
  spec.email         = ["masao@masoo.jp"]

  spec.summary       = "twilio-ruby wrapper"
  spec.description   = "twilio-ruby wrapper"
  spec.homepage      = "https://github.com/masoo/twilio_ruby_wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "twilio-ruby", '~> 4.13'
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
