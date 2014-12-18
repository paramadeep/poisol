require_relative "webmock_stub_builder"
require_relative "stub_class_builder"
require_relative "stub_instance"

class Stub
  include WebMockStubBuilder
  include StubInstance
  attr_accessor :request,:response
  class << self
    include StubClassBuilder

    def set_stub_config stub_config
      @stub_config = stub_config
      define_method("stub_config") do
        return stub_config
      end
    end
  end

end

class Request 
  attr_accessor :url,:query,:body
end

class Response 
  attr_accessor :body,:status
end


