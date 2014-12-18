describe Hash,"hashes extension" do
  it "camelize keys" do
    sample = {:ab_cd=>1,:ef_g=>{:hi_jk=>2}}
    expect(sample.camelize_keys).to eq({"abCd"=>1,"efG"=>{"hiJk"=>2}})
  end

it "stringify keys" do
    sample = {:ab_cd=>1,:ef_g=>{:hi_jk=>2}}
    expect(sample.stringify_keys).to eq({"ab_cd"=>1,"ef_g"=>{"hi_jk"=>2}})
  end
end
