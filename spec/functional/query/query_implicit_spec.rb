describe Poisol::Stub, "#implicit query params" do

  it "dynamic response" do
    Book.new.for_author_id("1").has_category({"age_group"=>"11", "publisher"=>{"name"=>"oxford"}}).build()
    response = RestClient.get "http://localhost:3030/book",{:params => {:author_id=>'1',:author_name=>"doni"}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"11", "genre"=>"action", "publisher"=>{"name"=>"oxford", "place"=>"erode"}}}.to_json)
  end

  it "default request and response" do
    Book.new.build()
    response = RestClient.get "http://localhost:3030/book",{:params => {:author_id=>'bharathi',:author_name=>"doni"}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"10", "genre"=>"action", "publisher"=>{"name"=>"summa", "place"=>"erode"}}}.to_json)
  end

  it "hash params for query" do
    Book.new.for(:author_id=>"1").build()
    response = RestClient.get "http://localhost:3030/book",{:params => {:author_id=>'1',:author_name=>"doni"}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"10", "genre"=>"action", "publisher"=>{"name"=>"summa", "place"=>"erode"}}}.to_json)
  end


end

