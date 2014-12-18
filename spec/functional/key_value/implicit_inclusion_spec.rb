describe Stub, "#key_value" do

  it "default request" do
    KeyValue.new.build()
    response = RestClient.post "http://localhost:80/keyvalue","name=sea&age=10"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

  it "partial dynamic request" do
    KeyValue.new.by_name("ram").build()
    response = RestClient.post "http://localhost:80/keyvalue","name=ram&age=10"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

  it "dynamic request" do
    KeyValue.new.by_name("ram").by_age(11).build()
    response = RestClient.post "http://localhost:80/keyvalue","name=ram&age=11"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

end
