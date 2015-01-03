describe Poisol::Stub, "#array" do

  it "default column array" do
    Columns.new.build
    response = RestClient.get "http://localhost:3030/column"
    expect(response.body).to eq({"title"=>["independance"], "category"=>["10"]}.to_json)
  end

  it "column array" do
    Columns.new.has_column.has_column.with_title("abc").with_category(12).build
    response = RestClient.get "http://localhost:3030/column"
    expect(response.body).to eq({"title"=>["independance", "abc"], "category"=>["10",12]}.to_json)
  end

  it "column array hash params" do
    Columns.new.has_column.has_column(:title=>"abc",:category => "12").build
    response = RestClient.get "http://localhost:3030/column"
    expect(response.body).to eq({"title"=>["independance", "abc"], "category"=>["10","12"]}.to_json)
  end

  it "column array full hash params" do
    Columns.new.has_columns([{:title=>"abc"},{:title=>"c",:category => "1"}]).build
    response = RestClient.get "http://localhost:3030/column"
    expect(response.body).to eq({"title"=>["abc", "c"], "category"=>["10","1"]}.to_json)
  end

  it "default row array" do
    Rows.new.build
    response = RestClient.get "http://localhost:3030/row"
    expect(response.body).to eq([{"title"=>"independance","items"=> [1,2],"category"=>{"age_group"=>"10"}}].to_json)
  end

  it "row array" do
    Rows.new.has_row.with_item(3).has_row.with_title("abc").with_category("age_group" => "12").with_items([2,3]).build
    response = RestClient.get "http://localhost:3030/row"
    expect(response.body).to eq([{"title"=>"independance","items"=> [1,2,3],"category"=>{"age_group"=>"10"}}, {"title"=>"abc","items"=> [2,3],"category"=>{"age_group"=>"12"}}].to_json)
  end

  it "row array hash_params" do
    Rows.new.has_row.has_row(:title=>"abc",:category=>{"age_group" => "12"}).build
    response = RestClient.get "http://localhost:3030/row"
    expect(response.body).to eq([{"title"=>"independance", "items"=> [1,2],"category"=>{"age_group"=>"10"}}, {"title"=>"abc", "items"=> [1,2],"category"=>{"age_group"=>"12"}}].to_json)
  end

  it "row array full hash_params" do
    Rows.new.has_rows([{},{:title=>"abc",:category=>{"age_group" => "12"}}]).build
    response = RestClient.get "http://localhost:3030/row"
    expect(response.body).to eq([{"title"=>"independance", "items"=> [1,2],"category"=>{"age_group"=>"10"}}, {"title"=>"abc", "items"=> [1,2],"category"=>{"age_group"=>"12"}}].to_json)
  end



end
