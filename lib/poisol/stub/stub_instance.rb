module Poisol
  module StubInstance
    def initialize
      init_request
      init_response
      @methods_called = []
    end

    def init_request
      @request = Request.new
      @request.type = stub_config.request.type
      @request.path = stub_config.request.url.deep_dup
      @request.query = stub_config.request.query_explicit ? {} : stub_config.request.query.deep_dup
      @request.body = stub_config.request.body_explicit ? {} : stub_config.request.body.deep_dup
    end

    def init_response
      @response = Response.new
      if  stub_config.response.is_column_array or stub_config.response.is_row_array 
        @response.body = [stub_config.response.body.deep_dup] 
      else
        @response.body = stub_config.response.body.deep_dup
      end
      @response.status = 200
      @response.header = {'Content-Type' => 'application/json'}
    end

    def set_dumb_response response_file
      @response.body = Parse.json_file_to_hash(response_file)
      @is_response_dumped = true
      self
    end

    def get_assignment_value actual_field_value,input_value
      if  actual_field_value.class.to_s == "Hash" 
        input_value = {} if input_value.blank?
        actual_field_value.deep_merge(input_value.stringify_keys) 
      else
        input_value
      end
    end

    def by input_hash
      @request.body.deep_merge! input_hash
      self
    end

    def has input_hash
      @response.body.deep_merge! input_hash.camelize_keys
      self
    end

    def  for input_hash
      @request.query.deep_merge! input_hash.camelize_keys
      self
    end

    def  status input
      @response.status = input
      self
    end

    def is_called_before?
      calling_method = caller[0]
      is_called = @methods_called.include? calling_method
      if is_called
        return true
      else
        @omethods_called = @methods_called << calling_method
        return false
      end
    end

  end
end
