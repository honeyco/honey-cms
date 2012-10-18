module CMS
  autoload :Routes,        'cms/routes'
  autoload :Configuration, 'cms/configuration'
  autoload :Type,          'cms/type'
  autoload :Attribute,     'cms/attribute'
  autoload :Helper,        'cms/helper'
  autoload :Orderable,     'cms/orderable'
  autoload :Uploader,      'cms/Uploader'
  autoload :ViewTags,      'cms/view_tags'
  autoload :FormBuilder,   'cms/form_builder'
end

Cms = CMS
