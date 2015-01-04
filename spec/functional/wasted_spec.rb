describe Poisol,"#wasted" do

  it "is wasted" do
    url = Url.new.build()
    url1 = Url.new.build()
    expect(Poisol.wasted).to eq [url,url1]
  end

  it "is not wasted" do
    url = Url.new.build()
    response = RestClient.get "http://localhost:3030/cda/cd/ragavan/get"
    expect(Poisol.wasted).to eq []
  end
end
