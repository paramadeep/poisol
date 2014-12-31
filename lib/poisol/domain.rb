class Domain
  attr_reader :file,:full_url

  def initialize domain_config_file
    @file = domain_config_file
    path = ""
    if File.exists? @file
      base_hash = Parse.yaml_file @file
      sub_domain  = base_hash["sub_domain"]
      path = "/#{sub_domain}" if sub_domain.present?
    end
    @full_url = "#{Server.base_url}#{ path.present? ? path: ''}"
  end

end
