# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "uby_interpreter"

Gem::Specification.new do |spec|
  spec.name          = "uby_interpreter"
  spec.version       = UbyInterpreter::VERSION
  spec.authors       = ["Hrvoje Šimić"]
  spec.email         = ["shime.ferovac@gmail.com"]
  spec.description   = %q{Simple Ruby interpreter}
  spec.summary       = %q{Simple Ruby interpreter}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "ruby_parser"
  spec.add_runtime_dependency "sexp_processor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
