describe Stub, "#nested array" do

  it "empty" do
    NestedArray.new.has_no_role.build()
    response = RestClient.get "http://localhost:80/nested_array"
    expect(response.body).to eq({"title"=>"ind", "roles"=>[]}.to_json)
  end

  it "without mentioning field" do
    NestedArray.new.build()
    response = RestClient.get "http://localhost:80/nested_array"
    expect(response.body).to eq({"title"=>"ind", "roles"=>[{"role_id"=>"chumma", "role_name"=>"sol"}]}.to_json)
  end

  it "mentioning one field" do
    NestedArray.new.has_role.build()
    response = RestClient.get "http://localhost:80/nested_array"
    expect(response.body).to eq({"title"=>"ind", "roles"=>[{"role_id"=>"chumma", "role_name"=>"sol"}]}.to_json)
  end

  it "mentioning one field with altered values" do
    NestedArray.new.has_role(:role_id=>"test1").build()
    response = RestClient.get "http://localhost:80/nested_array"
    expect(response.body).to eq({"title"=>"ind", "roles"=>[{"role_id"=>"test1", "role_name"=>"sol"}]}.to_json)
  end

  it "multiple fields with altered values" do
    NestedArray.new.has_role.has_another_role(:role_id=>"test").build()
    response = RestClient.get "http://localhost:80/nested_array"
    expect(response.body).to eq({"title"=>"ind", "roles"=>[{"role_id"=>"chumma", "role_name"=>"sol"},{"role_id"=>"test", "role_name"=>"sol"}]}.to_json)
  end

  it "passing array of hashes" do
    NestedArray.new.has_roles([{:role_id=>"test"},{:role_name=>"bla"}]).build()
    response = RestClient.get "http://localhost:80/nested_array"
    expect(response.body).to eq({"title"=>"ind", "roles"=>[{"role_id"=>"test", "role_name"=>"sol"},{"role_id"=>"chumma", "role_name"=>"bla"}]}.to_json)
  end

end
