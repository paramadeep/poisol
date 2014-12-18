module UrlBuilder
  def generate_methods_to_alter_path_params
    url = @stub_config.request.url
    url.scan(/{(.+?)}/).each do |path_params| 
      path_param = path_params[0]
      param_name = path_param.split("|")[0]
      param_default_value = path_param.split("|")[1]
      method_name = "of_#{param_name.underscore}"
      define_method(method_name) do |*input_value|
        input_value = input_value[0]
        @request.url.sub!("{#{path_param}}","{#{param_name}|#{input_value}}") unless input_value.blank?
          self
      end
    end
  end

end
