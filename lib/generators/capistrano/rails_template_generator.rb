module Capistrano
  class RailsTemplateGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../templates", __FILE__)
  
    desc "This generator adds all required files"
    def install
      root_path = File.expand_path("../../../templates", __FILE__)
      
      Dir.glob(root_path + '/lib/capistrano/**/*.*').each do |file|
        copy_file file, file.sub(root_path + '/', '')
      end
      
      Dir.glob(root_path + '/config/**/*.*').each do |file|
        copy_file file, file.sub(root_path + '/', '')
      end
    end
  end
end