describe StubInstance, "hash params" do
  it "default" do
    SimpleResponse.new.build
    response = RestClient.get "http://localhost:80/simple_response"
    expect(response.body).to eq({:a=>1,:b=>2}.to_json) 
  end
 
  it "partial" do
    SimpleResponse.new.has(:a=>3).build
    response = RestClient.get "http://localhost:80/simple_response"
    expect(response.body).to eq({:a=>3,:b=>2}.to_json) 
  end

   it "full" do
    SimpleResponse.new.has(:a=>3,:b=>5).build
    response = RestClient.get "http://localhost:80/simple_response"
    expect(response.body).to eq({:a=>3,:b=>5}.to_json) 
  end
 
end
