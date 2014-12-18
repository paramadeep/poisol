describe Stub, "#key_value" do

  it "partial dynamic request" do
    Explicit.new.by_name("ram").build()
    response = RestClient.post "http://localhost:80/explicit","name=ram"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

  it "dynamic request" do
    Explicit.new.by_name("ram").by_age(11).build()
    response = RestClient.post "http://localhost:80/explicit","name=ram&age=11"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end

end
