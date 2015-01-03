Gem::Specification.new do |s|
  s.name = 'poisol'
  s.version = '0.1.2'
  s.date = '2015-01-01'
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
  s.add_development_dependency 'webrick'
  s.add_development_dependency'rest-client'
  s.add_development_dependency 'activesupport'
end
