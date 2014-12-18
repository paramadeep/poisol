module Parse
  extend self

  def json_file_to_hash file_name
    JSON.parse File.read(file_name)
  end 

  def yaml_file file_name
    YAML.load_file(file_name)
  end

  def json_to_hash json
    JSON.parse json
  end

  def hash_array_to_column_hash hash_array
    return [] if hash_array.blank?
    column_hash = Hash.new
    hash_array[0].each_key { |key| column_hash.merge!(key=>[])}
    hash_array.each do |hash|
      column_hash.each_key {|key| column_hash[key].append hash[key]}
    end
    column_hash
  end

  def hash_to_concatenated_key_value hash
    concatenated_body = ""
    hash.each do |key,value|
      concatenated_body = concatenated_body + "#{key}=#{value}&"
    end
    concatenated_body.chomp('&')
  end

end
