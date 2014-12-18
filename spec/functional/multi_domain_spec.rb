describe Stub, "#multi domain" do

  it "support multi domain" do
    First.new.build
    response = RestClient.get "http://localhos:801/first"
    expect(response.body).to eq({"title"=>"1"}.to_json)
    Second.new.build
    response = RestClient.get "http://localhos:802/second"
    expect(response.body).to eq({"title"=>"1"}.to_json)
  end
end


