module Poisol 
  module ResponseMapper
    extend self

    def map webrick_request
      stub_request = get_stub_request webrick_request
      PoisolLog.info stub_request.to_s
      stub_response = get_stub_response stub_request
    end

    def get_stub_request webrick_request
      stub_request = Request.new 
      stub_request.type = webrick_request.request_method.downcase
      uri = webrick_request.request_uri
      stub_request.url = uri.query.blank? ? uri.to_s : uri.to_s.sub(uri.query,"").sub("?","")
      stub_request.query = webrick_request.query_string 
      stub_request.body = webrick_request.body
      stub_request
    end


    def get_stub_response stub_request
      stub = Stubs.get_match stub_request
      if stub.blank?
        PoisolLog.error "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^No match found for above request"
        PoisolLog.error "Registered requests are: #{Stubs.all.map{|stub| "\n#{stub.request.to_s}"}.join}\n--end--"
        raise "No match found for request: #{stub_request.to_s} "
      end
      return stub.response if stub.present?
    end

  end
end
