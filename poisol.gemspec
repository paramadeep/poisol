lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poisol/version'

Gem::Specification.new do |s|
  s.name = 'poisol'
  s.version = Poisol::VERSION
  s.date = '2016-04-28'
  s.summary = 'HTTP stub as DSL'
  s.description = 'HTTP stub as DSL'
  s.authors = ["Deepak"]
  s.files = Dir['README.md', 'lib/**/*']
  s.test_files = Dir['spec/**/*']
  s.homepage = 'https://github.com/paramadeep/poisol'
  s.license = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rubygems-tasks'
  s.add_development_dependency 'simplecov'
  s.add_runtime_dependency'rest-client', '~> 2.0.0'
  s.add_runtime_dependency 'webrick'
  s.add_runtime_dependency 'activesupport','~> 4.2.0'
end
