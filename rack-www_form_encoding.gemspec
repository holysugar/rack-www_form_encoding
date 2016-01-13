# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/www_form_encoding/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-www_form_encoding"
  spec.version       = Rack::WWWFormEncoding::VERSION
  spec.authors       = ["HORII Keima"]
  spec.email         = ["holysugar@gmail.com"]

  spec.summary       = %q{Encode from not UTF-8 www-form-urlencoded params to UTF-8 www-form-urlencoded params}
  spec.description   = %q{Encode from not UTF-8 www-form-urlencoded params to UTF-8 www-form-urlencoded params}
  spec.homepage      = "https://github.com/holysugar/rack-www_form_encoding"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
