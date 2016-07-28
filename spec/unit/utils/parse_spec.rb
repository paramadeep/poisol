describe Parse, 'parses hashes, yaml and much more' do
  it 'simple hash to concatenated key value' do
    sample = {:id => 1,:name => 'Arun'}
    concatenated_key_value = Parse.hash_to_concatenated_key_value sample
    expect(concatenated_key_value).to eq('id=1&name=Arun')
  end

  it 'nested hash with json data to concatenated key value' do
    sample = {:id => 1, :name => { :first => 'Arun', :last => 'S'}}
    concatenated_key_value = Parse.hash_to_concatenated_key_value sample
    expect(concatenated_key_value).to eq('id=1&name[first]=Arun&name[last]=S')
  end

  it 'hash with json data to concatenated key value' do
    sample = {:data => '{"id": 10, "name": {"first": "Arun", "last": "S"}}'}
    concatenated_key_value = Parse.hash_to_concatenated_key_value sample
    expect(concatenated_key_value).to eq('data=%7B%22id%22%3A+10%2C+%22name%22%3A+%7B%22first%22%3A+%22Arun%22%2C+%22last%22%3A+%22S%22%7D%7D')
  end
end
