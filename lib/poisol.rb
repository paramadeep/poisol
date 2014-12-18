require 'active_support/all'

Dir["#{File.dirname(__FILE__)}/poisol/**/*.rb"].each { |f| require(f) }

module Poisol
  extend self

  def load folder
    StubFactory.new.build folder
  end

  def log_all_calls to_domain
    WebMock.after_request(:real_requests_only => false) do |req_signature, response|
      if req_signature.to_s.include? to_domain
        PoisolLog.info "========================\nRequest\n#{req_signature.uri}\n#{req_signature.body}\nResponse:#{response.status[0]}\n#{JSON.pretty_generate(JSON.parse(response.body)) if response.status.present?}" 
      end
    end
  end
end
