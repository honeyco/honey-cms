module CMSHelper
  def form_for *args, &block
    options = args.extract_options!

    layout = if options.delete(:layout) == 'vertical'
      'form-vertical'
    else
      'form-horizontal'
    end

    args << options.reverse_merge(builder: CMS::FormBuilder, format: 'html', html: {class: layout})
    super *args, &block
  end
end
