require 'active_support/all'

Dir["#{File.dirname(__FILE__)}/poisol/**/*.rb"].each { |f| require(f) }

module Poisol
  extend self

  def start (param={:at_port=>3030})
    Server.start param[:at_port]
    reset
  end

  def load folder
    StubFactory.new.build folder 
  end

  def reset
    Stubs.reset
  end

  def stop
    Server.stop
    reset
  end

  def log_all_calls to_domain
    if req_signature.to_s.include? to_domain
      PoisolLog.info "========================\nRequest\n#{req_signature.uri}\n#{req_signature.body}\nResponse:#{response.status[0]}\n#{JSON.pretty_generate(JSON.parse(response.body)) if response.status.present?}" 
    end
  end
end
