module FileName
  extend self

  def get_dir_name file_name
    File.basename(File.dirname file_name)
  end

  def get_file_name file_name
    ((File.basename file_name).chomp ".yml")
  end

end

