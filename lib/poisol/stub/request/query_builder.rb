module QueryBuilder
    def generate_query_methods
      query = @stub_config.request.query 
      query.each do |field|
        field_name = field[0]
        define_method("for_#{field[0].underscore}") do |*value|
          @request.query[field_name] = value[0]
          self
        end
      end
    end
end
