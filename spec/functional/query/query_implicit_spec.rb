describe Stub, "#implicit query params" do

  it "dynamic response" do
    Book.new.for_author("bha").has_category({"age_group"=>"11", "publisher"=>{"name"=>"oxford"}}).build()
    response = RestClient.get "http://localhost:80/book",{:params => {:author=>'bha',:name=>"doni"}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"11", "genre"=>"action", "publisher"=>{"name"=>"oxford", "place"=>"erode"}}}.to_json)
  end

  it "default request and response" do
    Book.new.build()
    response = RestClient.get "http://localhost:80/book",{:params => {:author=>'bharathi',:name=>"doni"}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"10", "genre"=>"action", "publisher"=>{"name"=>"summa", "place"=>"erode"}}}.to_json)
  end

  it "hash params for query" do
    Book.new.for(:author=>"val").build()
    response = RestClient.get "http://localhost:80/book",{:params => {:author=>'val',:name=>"doni"}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"10", "genre"=>"action", "publisher"=>{"name"=>"summa", "place"=>"erode"}}}.to_json)
  end


end

