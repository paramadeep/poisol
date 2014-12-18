describe PoisolLog, "log" do
  it "default" do
      WebMock::NetConnectNotAllowedError.new WebMock::RequestSignature.new :get,"http://localhost:89675/blabl",{:body => "hi"}
  end
end 
