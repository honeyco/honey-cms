require 'rails/generators/active_record/migration'
require 'generators/cms/base'

module CMS
  module Generators

    class ContentTypes < Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration
      class_option :except, type: :array, default: [],
                            desc: 'skip certain types.'

      class_option :only, type: :string, default: false,
                          desc: 'run a specific type generator.'
    end

  end
end
