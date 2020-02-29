# frozen_string_literal: true

require './lib/hana_db/version'

Gem::Specification.new do |spec|
  spec.name        = 'hana_db'
  spec.version     = HanaDB::VERSION
  spec.authors     = ['torum']
  spec.email       = ['torum608@gmail.com']
  spec.description = spec.summary = 'Plain access to the SAP Hana database.'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n")
                                              .map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'connection_pool', '~> 2.2'
  spec.add_dependency 'ruby-odbc', '~> 0.99999'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'dotenv', '~> 2.7'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.70.0'
end
