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
  spec.add_dependency 'highline'
  spec.add_dependency 'jsonnet'
  spec.add_dependency 'logger'
  spec.add_dependency 'os'
  spec.add_dependency 'ruby-handlebars'
  spec.add_dependency 'thor'
  spec.add_dependency 'tty-prompt'
  spec.add_dependency 'tty-table'

  spec.add_development_dependency 'bump'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'doxie'
  spec.add_development_dependency 'private_gem'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubycritic'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
