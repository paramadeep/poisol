module RequestBodyBuilder

  def prepare_request_body
    return if @stub_config.request.body.blank?
    if  @stub_config.request.is_column_array or @stub_config.request.is_row_array 
      generate_methods_to_alter_request_array
    else
      generate_methods_to_alter_request_object 
    end
  end

  def generate_methods_to_alter_request_array
    @request_array_item = @stub_config.request.body
    generate_method_to_append_request_array
    generate_method_to_append_request_array_as_hash_params
    generate_method_to_alter_request_array_object
  end

  def generate_method_to_alter_request_array_object
    @request_array_item.each do |field|
      field_name = field[0]
      actual_field_value = field[1]
      is_array = (actual_field_value.class.to_s == "Array")
      actual_field_value = actual_field_value[0] if is_array
      method_name = is_array ? ("having_#{field_name.classify.underscore}") : ("having_#{field_name.underscore}")
      define_method(method_name) do |*input_value|
        input_value = input_value[0]
        assignment_value = get_assignment_value actual_field_value,input_value
        @request.body.last[field_name] = is_array ? (@request.body.last[field_name] << assignment_value) :  assignment_value
        self
      end
    end
  end

  def generate_method_to_append_request_array
    class_name = self.name.classify.underscore
    method_name = "by_#{class_name}"
    define_method(method_name) do |*input_value|
      if input_value.blank?
        @request.body << stub_config.request.body.deep_dup 
      else
        input = JSON.parse(input_value[0].to_json)
        @request.body << (stub_config.request.body.deep_dup).deep_merge!(input_value[0].stringify_keys)
      end
      self
    end
  end

  def generate_method_to_append_request_array_as_hash_params
    class_name = self.name.underscore
    method_name = "by_#{class_name}"
    define_method(method_name) do |*input_value|
      input_hashes = input_value[0]
      input_hashes.each do |input_hash|
        @request.body << (stub_config.request.body.deep_dup).deep_merge!(input_hash.stringify_keys)
      end
      self
    end
  end


  def generate_methods_to_alter_request_object
    request_body = @stub_config.request.body.clone
    request_body.each do |field|
      field_name = field[0]
      actual_field_value = field[1]
      is_array = (actual_field_value.class.to_s == "Array")
      if is_array 
        generate_method_to_alter_request_field_array field_name,actual_field_value
      else 
        generate_method_to_alter_request_field field_name,actual_field_value
      end
    end
  end

  def generate_method_to_alter_request_field_array field_name,actual_field_values
    actual_field_value = actual_field_values[0] 
    method_name = "by_#{field_name.classify.underscore}" 
    define_method(method_name) do |*input_value|
      input_value = input_value[0]
      assignment_value = get_assignment_value actual_field_value,input_value
      @request.body[field_name] =  [assignment_value]
      self
    end

    method_name = "by_another_#{field_name.classify.underscore}" 
    define_method(method_name) do |*input_value|
      input_value = input_value[0]
      assignment_value = get_assignment_value actual_field_value,input_value
      @request.body[field_name] =  @request.body[field_name] << assignment_value 
      self
    end

    method_name = "by_no_#{field_name.classify.underscore}" 
    define_method(method_name) do 
      @request.body[field_name] = [] 
      self
    end
  end

  def generate_method_to_alter_request_field field_name,actual_field_value
    method_name = "by_#{field_name.underscore}"
    define_method(method_name) do |*input_value|
      input_value = input_value[0]
      assignment_value = get_assignment_value actual_field_value,input_value
      @request.body[field_name] = assignment_value
      self
    end
  end


end
