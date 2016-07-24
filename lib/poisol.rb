require 'webrick'
require 'rest-client'
require 'active_support/all'
require 'poisol/all'

module Poisol
  extend self

  def start (param={:at_port=>3030})
    Server.start param[:at_port]
    reset_data
  end

  def load folder
    StubFactory.new.build folder 
  end

  def reset_data
    Stubs.reset
  end

  def stop
    Server.stop
    reset_data
  end

  def wasted
    Stubs.unused
  end
end
