module Poisol
  module BuildStub
    def build
      @stub = Stub.new
      build_url
      build_query
      build_request_body
      build_response
      Stubs.add @stub
      @stub
    end

    private
    def build_url
      remove_path_param_name_from_url
      @stub.request.type =  @request.type
      @stub.request.url =  "#{stub_config.request.domain}/#{@request.path}"
    end

    def build_query
      return if @request.query.blank?
      @stub.request.query = @request.query.to_query
    end

    def build_request_body
      if stub_config.request.is_body_key_value
        @stub.request.body =  Parse.hash_to_concatenated_key_value(@request.body)
      else
        @stub.request.body = @request.body
      end
    end

    def build_response
      @stub.response.status = @response.status
      @stub.response.header = @response.header
      if stub_config.response.is_column_array and !@is_response_dumped.present?
        @stub.response.body = Parse.hash_array_to_column_hash(@response.body) 
      else
        @stub.response.body = @response.body
      end
    end

    def remove_path_param_name_from_url
      @request.path.scan(/{(.+?)}/).each do |path_params|
        path_param = path_params[0]                                      
        param_name = path_param.split("|")[0]  
        param_value = path_param.split("|")[1]
        @request.path.sub!("{#{path_param}}",param_value)
      end
    end

  end
end
