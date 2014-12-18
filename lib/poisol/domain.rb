class Domain
  attr_reader :file,:full_url

  def initialize domain_config_file
    @file = domain_config_file
    base_hash = Parse.yaml_file @file
    domain  = base_hash["domain"]
    port = base_hash["port"]
    @full_url = "#{domain.chomp('\\')}#{ port.present? ? ":#{port}" : "" }"
  end

end
