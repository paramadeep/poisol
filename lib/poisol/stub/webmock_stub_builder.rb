module WebMockStubBuilder
  def build
    build_url
    build_query
    build_request_body
    build_response_body
    return @webmock_stub
  end

  private
  def build_url
    remove_path_param_name_from_url
    @webmock_stub = stub_request(stub_config.request.type, "http://#{stub_config.request.domain}/#{@request.url}")
  end

  def build_query
    @webmock_stub.with(:query => @request.query) unless @request.query.eql? ""
  end

  def build_request_body
    return if  @request.body.blank? 
    @request.body =  Parse.hash_to_concatenated_key_value(@request.body) if stub_config.request.is_body_key_value
    @webmock_stub.with(:body => @request.body)
  end

  def build_response_body
    @response.body = Parse.hash_array_to_column_hash(@response.body) if stub_config.response.is_column_array and !@is_response_dumped.present?
    @webmock_stub.to_return(:status => @response.status, :body => @response.body.to_json, :headers => {'Content-Type' => 'application/json'})
  end

  def remove_path_param_name_from_url
    @request.url.scan(/{(.+?)}/).each do |path_params|
      path_param = path_params[0]                                      
      param_name = path_param.split("|")[0]  
      param_value = path_param.split("|")[1]
      @request.url.sub!("{#{path_param}}",param_value)
    end
  end

end
