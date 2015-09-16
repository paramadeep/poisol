describe Poisol::Stub, "#query_optional" do

  it "with & without optional param" do
    BookOptional.new.build
    BookOptional.new.for_author('bha').build

    response = RestClient.get "http://localhost:3030/book_optional",{:params => {:author=>'bha'}}
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"10", "genre"=>"action", "publisher"=>{"name"=>"summa", "place"=>"erode"}}}.to_json)

    response = RestClient.get "http://localhost:3030/book_optional"
    expect(response.body).to eq({"title"=>"independance", "category"=>{"age_group"=>"10", "genre"=>"action", "publisher"=>{"name"=>"summa", "place"=>"erode"}}}.to_json)

  end

end
