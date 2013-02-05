require 'cms/inflections'
require 'redcarpet'

module CMS
  class Engine < ::Rails::Engine
    initializer 'cms.markdown' do |app|
      ::Markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        autolink: true,
        space_after_headers: true,
        superscript: true,
        tables: true,
        hard_wrap: true)
    end
  end
end
