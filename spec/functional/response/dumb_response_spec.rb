describe Stub, "#dumb response" do

  it "column array" do
    Columns.new.set_dumb_response("spec/data/main/user/response.json").build
    response = RestClient.get "http://localhost:80/column"
    expect(response.body).to eq({"job"=>"sleeping_bag"}.to_json)
  end

end
