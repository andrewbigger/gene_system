# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gene_system/version'

Gem::Specification.new do |spec|
  spec.name          = 'gene_system'
  spec.version       = GeneSystem::VERSION
  spec.authors       = ['Andrew Bigger']
  spec.email         = ['andrew.bigger@gmail.com']
  spec.summary       = 'System configuration tool for applying settings'
  spec.homepage      = 'https://github.com/andrewbigger/gene_system'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'hashie'
  spec.add_dependency 'highline', '~> 2.0'
  spec.add_dependency 'jsonnet'
  spec.add_dependency 'logger', '~> 1.4'
  spec.add_dependency 'os'
  spec.add_dependency 'ruby-handlebars', '~> 0.4'

  spec.add_development_dependency 'bump', '~> 0.6'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'doxie'
  spec.add_development_dependency 'private_gem', '~> 1.1'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'puma', '~> 4.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  spec.add_development_dependency 'rubocop', '~> 0.58'
  spec.add_development_dependency 'rubycritic', '~> 3.4', '>= 3.4.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'yard', '~> 0.9'
end
