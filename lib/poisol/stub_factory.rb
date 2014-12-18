require_relative "stub/stub"

class StubFactory
  def build folder
    @folder = folder.chomp '/'
    load_domain
    load_stub_configs
  end

  private

  def load_domain
    domain_config_file = Dir["#{@folder}/domain.yml"].first
    @domain = Domain.new domain_config_file
  end

  def load_stub_configs
    explolded_configs =  Dir["#{@folder}/**/config.yml"]
    inline_configs = Dir["#{@folder}/**/*.yml"] - ( (explolded_configs.nil?) ?  [] : explolded_configs) - [@domain.file]
    generate_exploded_config explolded_configs unless explolded_configs.nil?
    generate_inline_config inline_configs unless inline_configs.nil?
  end


  def generate_exploded_config explolded_configs
    explolded_configs.each do |config_file|
      PoisolLog.info "Processing #{config_file}"
      dynamic_name = (FileName.get_dir_name config_file).camelize
      config = StubConfigBuilder.new.is_exploded.with_file(config_file).with_domain(@domain.full_url).build
      create_class dynamic_name,config
    end
  end

  def generate_inline_config inline_configs
    inline_configs.each do |config_file|
      PoisolLog.debug "Processing #{config_file}"
      dynamic_name = (FileName.get_file_name config_file).camelize
      stub_config = StubConfigBuilder.new.is_inline.with_file(config_file).with_domain(@domain.full_url).build
      create_class dynamic_name,stub_config
    end
  end

  def create_class class_name,stub_config
    dynamic_stub_class = Object.const_set class_name,Class.new(Stub)
    dynamic_stub_class.set_stub_config stub_config
    dynamic_stub_class.generate_methods_to_alter_sutb
    PoisolLog.info "Generated #{class_name}"
    PoisolLog.debug "with methods #{dynamic_stub_class.instance_methods - Object.methods}"
  end

end
