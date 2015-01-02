describe Poisol::Stub, "#multi domain" do

  it "support multi domain" do
    First.new.build
    response = RestClient.get "http://localhost:3030/first/first"
    expect(response.body).to eq({"title"=>"1"}.to_json)
    Second.new.build
    response = RestClient.get "http://localhost:3030/second/second"
    expect(response.body).to eq({"title"=>"1"}.to_json)
  end
end


