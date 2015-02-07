# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "embulk-plugin-input-roo-excel"
  spec.version       = "0.1.1"
  spec.authors       = ["Hiroyuki Sato"]
  spec.email         = ["hiroysato@gmail.com"]
  spec.summary       = %q{Embulk input plugin to read xlsx files}
  spec.description   = %q{Embulk input plugin to read xlsx files}
  spec.homepage      = "https://github.com/hiroyuki-sato/embulk-plugin-input-roo-excel"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "roo"
end
