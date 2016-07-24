describe Poisol::Stub, "#key_value" do

  it "default request" do
    KeyValue.new.build()
    response = RestClient.post "http://localhost:3030/keyvalue","name[first]=sea&name[last]=gull&age=10&extra_info=none"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

  it "partial dynamic request" do
    KeyValue.new.by_name({:first => "ram", :last => "kumar"}).build()
    response = RestClient.post "http://localhost:3030/keyvalue","name[first]=ram&name[last]=kumar&age=10&extra_info=none"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

  it "dynamic request" do
    KeyValue.new.by_name({:first => "ram", :last => "raj"}).by_age(11).build()
    response = RestClient.post "http://localhost:3030/keyvalue","name[first]=ram&name[last]=raj&age=11&extra_info=none"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

  it "dynamic request containing url encoded json data" do
    KeyValue.new.by_name({:first => "ram", :last => "raj"}).by_age(11).by_extra_info('{"father": "sridhar", "mother": "sita"}').build()
    response = RestClient.post "http://localhost:3030/keyvalue","name[first]=ram&name[last]=raj&age=11&extra_info=%7B%22father%22%3A+%22sridhar%22%2C+%22mother%22%3A+%22sita%22%7D"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

end
