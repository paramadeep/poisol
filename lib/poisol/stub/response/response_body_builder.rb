module Poisol 
  module ResponseBodyBuilder

    def prepare_response_body
      return if @stub_config.response.body.blank?
      if  @stub_config.response.is_column_array or @stub_config.response.is_row_array 
        make_methods_to_alter_response_array
      else
        make_methods_to_alter_response_object 
      end
    end

    def make_methods_to_alter_response_object
      response_body = @stub_config.response.body.clone
      response_body.each do |field|
        field_name = field[0]
        actual_field_value = field[1]
        is_array = (actual_field_value.class.to_s == "Array")
        if is_array 
          make_method_to_alter_response_nested_array field_name,actual_field_value
        else 
          make_method_to_alter_response_field field_name,actual_field_value
        end
      end
    end

    def make_method_to_alter_response_nested_array field_name,actual_field_values
      actual_field_value = actual_field_values[0] 

      method_name = "has_#{field_name.underscore}" 
      define_method(method_name) do |*input_value|
        @response.body[field_name]  = []
        input_hashes = input_value[0]
        input_hashes.each do |input_hash|
          assignment_value = get_assignment_value actual_field_value.deep_dup,input_hash.stringify_keys
          @response.body[field_name] << assignment_value
        end
        self
      end


      method_name = "has_#{field_name.classify.underscore}" 
      define_method(method_name) do |*input_value|
        input_value = input_value[0]
        assignment_value = get_assignment_value actual_field_value,input_value
        @response.body[field_name] = @called_methods.include?(__method__) ?  @response.body[field_name] << assignment_value  :[assignment_value] 
        @called_methods << __method__
        self
      end

      method_name = "has_no_#{field_name.classify.underscore}" 
      define_method(method_name) do 
        @response.body[field_name] = [] 
        self
      end
    end

    def make_method_to_alter_response_field field_name,actual_field_value
      method_name = "has_#{field_name.underscore}"
      define_method(method_name) do |*input_value|
        input_value = input_value[0]
        assignment_value = get_assignment_value actual_field_value,input_value
        @response.body[field_name] = assignment_value
        self
      end
    end
  end

end
