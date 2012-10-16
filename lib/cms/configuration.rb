module CMS::Configuration
  def data
    @data = YAML.load(File.read(Rails.root.join 'config/cms.yml'))
  end

  def scoped_types options
    if options[:only]
      [types.find{|t| options[:only] == t.name}]
    else
      types.reject{|t| options[:except].include?(t.name)}
    end
  end

  def types
    if defined?(@types) then return @types end

    @types = data['content_types'].map do |name, config|
      CMS::Type.new(name, config.delete('attributes'), config)
    end

    @types.each do |type|
      type.attributes = attributes(type.attributes, type)
    end

    @types
  end

  def attributes attributes, type
    attributes.map do |args|
      options = args.extract_options!
      name = args.shift
      format = args.pop || options.delete('format')
      attribute = CMS::Attribute.new(name, format, options)
      attribute.reference_to.references << type if attribute.reference?
      attribute
    end
  end

  extend self
end