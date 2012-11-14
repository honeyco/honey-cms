class CMS::Page
  attr_reader :route, :options

  def initialize route, options
    @options = options
    @route = (options[:route] || route).dup
  end

  def action
    @action ||= (options[:action] || route).dup
  end

  def editable?
    !options[:static]
  end
end
