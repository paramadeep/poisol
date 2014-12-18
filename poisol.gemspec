Gem::Specification.new do |s|
  s.name = 'poisol'
  s.version = '0.0.15'
  s.date = '2014-12-18'
  s.summary = 'Generate builders for http stubs'
  s.description = "Generate builders for http stubs"
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
  s.add_development_dependency'webmock'
  s.add_development_dependency'rest-client'
  s.add_development_dependency 'activesupport'
end
