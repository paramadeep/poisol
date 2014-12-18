module WebMock
  class NetConnectNotAllowedError
    alias real_init initialize
    def initialize(*args)
      exception = real_init *args
      request = args[0]
      PoisolLog.error "**************Failed************\n#{request.method}:#{request.uri}\n#{request.body if request.body.present?}\n#{request_stubs}"
      exception
    end
  end
end
