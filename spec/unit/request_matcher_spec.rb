describe Poisol::RequestMatcher, "request matching" do
  it "match hashes" do
    hash1 = {"store_group_id"=>["5008"], "date"=>["2029-12-28"], "pr_discount_percentage"=>["0.00000"]}
    hash2 = {"date"=>["2029-12-28"], "pr_discount_percentage"=>["0.00000"], "store_group_id"=>["5008"]}
    expect(Poisol::RequestMatcher.matching_hashes?(hash1,hash2)).to eq true
  end
end 
