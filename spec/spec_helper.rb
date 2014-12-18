require "rspec/expectations"
require 'rest_client'
require 'webmock'
include WebMock::API

require_relative '../lib/poisol'
require 'pry'

require 'simplecov'
SimpleCov.minimum_coverage 40
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start

RSpec.configure do |config|

  config.before(:each) do
    WebMock.reset!
  end

  config.before(:suite) do
    WebMock.disable_net_connect!
    factory = StubFactory.new.build("spec/data/main")
    factory = StubFactory.new.build("spec/data/domain/first/")
    factory = StubFactory.new.build("spec/data/domain/second/")
  end

end

