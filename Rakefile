require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/packagetask'
require 'rubygems/tasks'
Gem::Tasks.new(
  :build => {:gem => true},
  :sign => {:checksum => true, :pgp => true}
)
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

task :make_request do
  response_body_builder = "lib/poisol/stub/response/response_body_builder.rb"
  request_body_builder = "lib/poisol/stub/request/request_body_builder.rb"
  text = File.read(response_body_builder)
  text.gsub!("Response", "Request")
  text.gsub!("response", "request")
  text.gsub!("has_", "by_")
  text.gsub!("with_", "having_")
  File.open(request_body_builder, "w") {|file| file.puts text }
end 
