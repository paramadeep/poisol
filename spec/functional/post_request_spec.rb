describe Stub, "#post_user" do

  it "default request and response" do
    User.new.build()
    response = RestClient.post "http://localhost:80/users","name"=>"deepak"
    expect(response.body).to eq({"job"=>'sleeping_bag'}.to_json)
  end

  it "dynamic request and response" do
    name = "ummy"
    job = "vetti"
    User.new.by_name(name).has_job(job).build()
    response = RestClient.post "http://localhost:80/users","name"=>name
    expect(response.body).to eq({"job"=>job}.to_json)
  end

end

