describe "adding and retiral of stubs" do 
  it "returns the last matching request" do
    stub = Poisol::Stub.new
    stub.request.url = "url"
    stub.response.status = 200
    Poisol::Stubs.add stub 
    stub.response.status = 300
    Poisol::Stubs.add stub 
    matched_stub = Poisol::Stubs.get_match stub.request
    expect(matched_stub.response.status).to eq 300
  end
end
