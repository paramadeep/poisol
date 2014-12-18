module ResponseBodyBuilder

  def prepare_response_body
    return if @stub_config.response.body.blank?
    if  @stub_config.response.is_column_array or @stub_config.response.is_row_array 
      generate_methods_to_alter_response_array
    else
      generate_methods_to_alter_response_object 
    end
  end

  def generate_methods_to_alter_response_array
    @response_array_item = @stub_config.response.body
    generate_method_to_append_response_array
    generate_method_to_append_response_array_as_hash_params
    generate_method_to_alter_response_array_object
  end

  def generate_method_to_alter_response_array_object
    @response_array_item.each do |field|
      field_name = field[0]
      actual_field_value = field[1]
      is_array = (actual_field_value.class.to_s == "Array")
      actual_field_value = actual_field_value[0] if is_array
      method_name = is_array ? ("with_#{field_name.classify.underscore}") : ("with_#{field_name.underscore}")
      define_method(method_name) do |*input_value|
        input_value = input_value[0]
        assignment_value = get_assignment_value actual_field_value,input_value
        @response.body.last[field_name] = is_array ? (@response.body.last[field_name] << assignment_value) :  assignment_value
        self
      end
    end
  end

  def generate_method_to_append_response_array
    class_name = self.name.classify.underscore
    method_name = "has_#{class_name}"
    define_method(method_name) do |*input_value|
      if input_value.blank?
        @response.body << stub_config.response.body.deep_dup 
      else
        input = JSON.parse(input_value[0].to_json)
        @response.body << (stub_config.response.body.deep_dup).deep_merge!(input_value[0].stringify_keys)
      end
      self
    end
  end

  def generate_method_to_append_response_array_as_hash_params
    class_name = self.name.underscore
    method_name = "has_#{class_name}"
    define_method(method_name) do |*input_value|
      input_hashes = input_value[0]
      input_hashes.each do |input_hash|
        @response.body << (stub_config.response.body.deep_dup).deep_merge!(input_hash.stringify_keys)
      end
      self
    end
  end


  def generate_methods_to_alter_response_object
    response_body = @stub_config.response.body.clone
    response_body.each do |field|
      field_name = field[0]
      actual_field_value = field[1]
      is_array = (actual_field_value.class.to_s == "Array")
      if is_array 
        generate_method_to_alter_response_field_array field_name,actual_field_value
      else 
        generate_method_to_alter_response_field field_name,actual_field_value
      end
    end
  end

  def generate_method_to_alter_response_field_array field_name,actual_field_values
    actual_field_value = actual_field_values[0] 
    method_name = "has_#{field_name.classify.underscore}" 
    define_method(method_name) do |*input_value|
      input_value = input_value[0]
      assignment_value = get_assignment_value actual_field_value,input_value
      @response.body[field_name] =  [assignment_value]
      self
    end

    method_name = "has_another_#{field_name.classify.underscore}" 
    define_method(method_name) do |*input_value|
      input_value = input_value[0]
      assignment_value = get_assignment_value actual_field_value,input_value
      @response.body[field_name] =  @response.body[field_name] << assignment_value 
      self
    end

    method_name = "has_no_#{field_name.classify.underscore}" 
    define_method(method_name) do 
      @response.body[field_name] = [] 
      self
    end
  end

  def generate_method_to_alter_response_field field_name,actual_field_value
    method_name = "has_#{field_name.underscore}"
    define_method(method_name) do |*input_value|
      input_value = input_value[0]
      assignment_value = get_assignment_value actual_field_value,input_value
      @response.body[field_name] = assignment_value
      self
    end
  end


end
