describe "Delete" do 
  it "for delete request" do
    Delete.new.build
    response = RestClient.delete "http://localhost:3030/delete_url"
    expect(response.body).to eq({"hi"=>1}.to_json)
  end
end
