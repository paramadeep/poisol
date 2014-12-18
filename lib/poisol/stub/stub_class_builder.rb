require_relative "request/query_builder"
require_relative "request/request_body_builder"
require_relative "request/url_builder"
require_relative "response/response_body_builder"
require_relative "response/status_builder"

module StubClassBuilder
  include RequestBodyBuilder 
  include ResponseBodyBuilder 
  include UrlBuilder 
  include QueryBuilder 

  def generate_methods_to_alter_sutb
    prepare_request
    prepare_response
  end

  def prepare_request
    prepare_request_url
    prepare_request_query
    prepare_request_body
  end

  def prepare_request_url
    generate_methods_to_alter_path_params
  end

  def prepare_request_query
    generate_query_methods if @stub_config.request.query.present?
  end

  def prepare_response
    prepare_response_body
  end

end
