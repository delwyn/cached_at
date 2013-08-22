# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cached_at/version'

Gem::Specification.new do |spec|
  spec.name          = "cached_at"
  spec.version       = CachedAt::VERSION
  spec.authors       = ["Delwyn de Villiers"]
  spec.email         = ["delwyn.d@gmail.com"]
  spec.description   = %q{Use cached_at for ActiveRecord cache key}
  spec.summary       = %q{Use cached_at for ActiveRecord cache key instead of updated at}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord", "~> 3.2"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "sqlite3"
end
