require 'rails/generators/active_record/migration'

class CmsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration

  class_option :except, type: :array, default: [],
                        desc: 'skip certain types.'

  class_option :only, type: :string, default: false,
                      desc: 'run a specific type generator.'

  class_option :migrate, type: :boolean, default: false,
                         desc: 'generate the migration'

  class_option :controller, type: :boolean, default: false,
                            desc: 'generate the controller'

  def create_migration_file
    if options[:only].present?
      migration_template 'migration.rb', "db/migrate/create_#{options[:only].underscore.pluralize}" if options[:migrate]
    else
      migration_template 'migration.rb', 'db/migrate/create_cms' if options[:migrate]
    end
  end

  def copy_controller_file
    template 'cms_base_controller.rb', 'app/controllers/cms/base_controller.rb' if options[:controller]

    empty_directory 'app/controllers/cms'
    empty_directory 'app/models/cms'

    CMS::Configuration.scoped_types(options).each do |type|
      @name = (@type = type).model_name
      template 'type_controller.rb', "app/controllers/cms/#{@name.collection}_controller.rb"
      template 'type_model.rb',      "app/models/cms/#{@name.element}.rb"

      %w(index new show edit).each do |view|
        template "views/#{view}.html.haml", "app/views/cms/#{@name.collection}/#{view}.html.haml"
      end
    end
  end
end
