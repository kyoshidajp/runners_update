# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'runners_update/version'

Gem::Specification.new do |spec|
  spec.name          = 'runners_update'
  spec.version       = RunnersUpdate::VERSION
  spec.authors       = ['kyoshidajp']
  spec.email         = ['claddvd@gmail.com']

  spec.summary       = 'ランナーズアップデートのデータ取得'
  spec.description   = 'ランナーズアップデートのデータ取得'
  spec.homepage      = 'https://github.com/kyoshidajp/runners_update'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0').reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10.a'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
