class StubConfigBuilder

  def initialize
    @stub_config = StubConfig.new
    @stub_config.request = RequestConfig.new
    @stub_config.response = ResponseConfig.new
  end

  def with_file file_name
    @stub_config.file = file_name
    self
  end

  def with_domain domain
    @stub_config.request.domain = domain
    self
  end

  def is_inline
    @stub_config.is_inline = true
    self
  end

  def is_exploded
    @stub_config.is_inline = false
    self
  end

  def build
    @raw_config_hash = Parse.yaml_file @stub_config.file 
    build_request
    build_response
    return @stub_config
  end

  private
  def build_request
    load_url
    @stub_config.request.type = @raw_config_hash["request"]["type"].intern
    load_query
    load_request_body
  end
  
  def load_request_body
    load_request_body_filed_implicit_option
    @stub_config.is_inline ? load_inline_request_body : load_exploaded_request_body
  end


  def load_query
    @stub_config.request.query = @raw_config_hash["request"]["query"]
    query_explicit = @raw_config_hash["request"]["query_explicit"]
    @stub_config.request.query_explicit = query_explicit.blank? ? false : query_explicit
  end


  def load_url
    url = @raw_config_hash["request"]["url"]
    url.strip!
    url.sub!("/","") if url[0].eql? "/"
    @stub_config.request.url = url
  end

  def load_request_body_filed_implicit_option
    body_explicit = @raw_config_hash["request"]["body_explicit"]
    @stub_config.request.body_explicit = body_explicit.blank? ? false : body_explicit
  end


  def build_response
    @stub_config.is_inline ? load_inline_response_body  : load_exploaded_response_body
    load_resonse_array_type
  end

  def load_resonse_array_type
    return if @raw_config_hash["response"].blank?
    array_type = @raw_config_hash["response"]["array_type"]
    return if array_type.blank?
    @stub_config.response.is_column_array = true  if array_type.eql? "column"
    @stub_config.response.is_row_array = true  if array_type.eql? "row"
  end


  def load_inline_response_body
    raw_body = @raw_config_hash["response"]["body"]
    return if raw_body.blank?
    @stub_config.response.body = Parse.json_to_hash raw_body
  end

  def load_inline_request_body
    raw_body = @raw_config_hash["request"]["body"]
    return if raw_body.blank?
    if raw_body.class.name == "String"
      @stub_config.request.body = Parse.json_to_hash raw_body
    else
      @stub_config.request.is_body_key_value = true
      @stub_config.request.body = raw_body
    end
  end

  def load_exploaded_request_body
    request_file = "#{File.dirname @stub_config.file}/request.json"
    return  unless File.exists? request_file
    @stub_config.request.body = Parse.json_file_to_hash(request_file)
  end

  def load_exploaded_response_body
    response_file = "#{File.dirname @stub_config.file}/response.json"
    return  unless File.exists? response_file
     @stub_config.response.body = Parse.json_file_to_hash(response_file)
  end
end
