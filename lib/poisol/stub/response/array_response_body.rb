module Poisol 
  module ResponseBodyBuilder

    def make_methods_to_alter_response_array
      @response_array_item = @stub_config.response.body
      make_method_to_append_response_array
      make_method_to_append_response_array_as_hash_params
      make_method_to_alter_response_array_object
    end

    def make_method_to_append_response_array
      class_name = self.name.classify.underscore
      method_name = "has_#{class_name}"
      define_method(method_name) do |*input_value|
        assignment_value = input_value.blank? ? 
          stub_config.response.body.deep_dup : 
          (stub_config.response.body.deep_dup).deep_merge!(input_value[0].stringify_keys)
        if is_called_before?
          @response.body << assignment_value
        else
          @response.body = [assignment_value]
        end
        self
      end
    end

    def make_method_to_append_response_array_as_hash_params
      class_name = self.name.underscore
      method_name = "has_#{class_name}"
      define_method(method_name) do |*input_value|
        @response.body = []
        input_hashes = input_value[0]
        input_hashes.each do |input_hash|
          @response.body << (stub_config.response.body.deep_dup).deep_merge!(input_hash.stringify_keys)
        end
        self
      end
    end

    def make_method_to_alter_response_array_object
      @response_array_item.each do |field|
        field_name = field[0]
        actual_field_value = field[1]
        is_array = (actual_field_value.class.to_s == "Array")
        actual_field_value = actual_field_value[0] if is_array

        method_name = "with_#{field_name.underscore}"
        define_method(method_name) do |*input_value|
          input_value = input_value[0]
          assignment_value = get_assignment_value actual_field_value,input_value
          @response.body.last[field_name] =  assignment_value
          self
        end

        if is_array
          method_name = "with_#{field_name.classify.underscore}"
          define_method(method_name) do |*input_value|
            input_value = input_value[0]
            assignment_value = get_assignment_value actual_field_value,input_value
            @response.body.last[field_name] = @response.body.last[field_name] << assignment_value
            self
          end
        end

      end
    end
  end
end
