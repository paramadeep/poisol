module WebrickStubBuilder
  def build
    build_url
    build_query
    build_request_body
    build_response_body
    Stubs.add self
    self
  end

  private
  def build_url
    remove_path_param_name_from_url
    @request.url =  "#{stub_config.request.domain}/#{@request.path}"
  end

  def build_query
    return if @request.query.blank?
    @request.query = @request.query.to_query
  end

  def build_request_body
    return if  @request.body.blank? 
    @request.body =  Parse.hash_to_concatenated_key_value(@request.body) if stub_config.request.is_body_key_value
  end

  def build_response_body
    @response.body = Parse.hash_array_to_column_hash(@response.body) if stub_config.response.is_column_array and !@is_response_dumped.present?
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
