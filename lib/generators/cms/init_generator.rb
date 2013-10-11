require 'generators/cms/base'

module CMS
  module Generators

    class Init < Base
      source_root File.expand_path('../templates', __FILE__)

      def create_config
        template 'cms_helper.rb', 'app/helpers/cms_helper.rb'
      end
    end

  end
end
