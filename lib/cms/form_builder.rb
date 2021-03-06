class CMS::FormBuilder < ActionView::Helpers::FormBuilder ; end

module CMS::FormBuilder::Fields
  LABEL_WIDTH = 'col-lg-2'
  FIELD_WIDTH = 'col-lg-4'

  def radio name, *args
    args = _apply_field_defaults(args)
    options = args.extract_options!
    values = args
    field_wrapper :radio, name do
      out = ''.html_safe
      out.concat label(name, class: "#{LABEL_WIDTH} control-label") if options[:label]

      value_div = @template.content_tag(:div, class: "#{FIELD_WIDTH} radio") do
        values.map do |value|
          @template.content_tag :span, class: 'value' do
            if value.is_a? Array
              radio_button(name, value[1].html_safe) + label(name, value[0].html_safe, value: value[1])
            else
              radio_button(name, value) + label(name, value, value: value)
            end
          end
        end.join("\n").html_safe
      end

      out.concat value_div
    end
  end

  def location name, options
    autocomplete name, options.merge(prepend: @template.content_tag(:div, '', class: 'geolocate'))
  end

  def autocomplete name, *args
    args = _apply_field_defaults(args)
    options = args.extract_options!
    options.reverse_merge!(waiting: 'Searching...')

    option_text = '<div class="options"><div class="inner">'.html_safe
    option_text.concat @template.content_tag(:div, options[:waiting], class: 'waiting')
    option_text.concat '<div class="results"></div>'.html_safe
    option_text.concat '</div></div>'.html_safe

    field_wrapper(:autocomplete, name) do
      out = ''.html_safe
      if options[:label] == true
        out.concat label(name)
      elsif options[:label]
        out.concat label(name, options[:label])
      end
      out.concat @template.link_to 'learn more', '#', class: 'tipsy', title: send("#{name}_help_text") if options[:help_text]
      options[:help_text] = false
      out.concat string(name, options.merge(autocomplete: false, label: false, append: option_text))
    end
  end

  def text_with_counter name, *args
    args = _apply_field_defaults(args)
    options = args.extract_options!

    unless options[:length].blank?
      counter = "<div class=\"counter\"><span class=\"count\">0</span>/<span class=\"maximum\">#{options[:length]}</span></div>".html_safe
    end

    text(name, options.merge(label: options[:label], append: counter))
  end

  def boolean *args
    field :boolean, *_apply_default_options(args, label_first: false)
  end

  def string *args
    field :string, *args
  end

  def file *args
    field :file, *args
  end

  def search *args
    field :search, *args
  end

  def text *args
    field :text, *args
  end

  def email *args
    field :email, *args
  end

  def password *args
    field :password, *args
  end

  def hidden *args
    field :hidden, *_apply_default_options(args, label: false, wrap_field: false)
  end

  def choices attribute, choices, *args
    field :choices, *_apply_default_options(args << attribute,  choices: choices)
  end

  # slider is weird enough that we will not use the default field helper.
  # instead, we will construct our own field that looks like a regular field.
  def slider name, *args
    args = _apply_field_defaults(args)
    options = args.extract_options!
    out = ''.html_safe

    field_wrapper :slider, name do
      out.concat label(name, options[:label]) if options[:label]
      out.concat @template.content_tag :div, '', class: 'slider-edit'
      out.concat hidden(name)
    end
  end

  def toggle name, *args
    args = _apply_field_defaults(args)
    options = args.extract_options!
    out = ''.html_safe

    field_wrapper :toggle, name, :'data-default' => options[:default] do
      out.concat label(name) if options[:label]
      out.concat(@template.content_tag(:div, class: (object.send(name) ? 'visible' : 'hidden')) do
        check_box(name) << @template.label_tag(object.send(name) ? 'visible' : 'hidden')
      end)
    end
  end

  def actions options = {}
    options.reverse_merge! save: 'Save', saving: 'Saving...', class: 'form-actions', save_class: 'btn btn-primary'
    @template.content_tag(:div, class: options.delete(:class)) do
      actions = ''.html_safe
      actions << submit(options[:save], disable_with: options[:saving], class: options[:save_class])
      actions << status
    end
  end

  def modal_actions options = {}
    options.reverse_merge! save: 'Save', saving: 'Saving...', class: 'modal-footer'
    @template.content_tag(:div, class: options.delete(:class)) do
      actions = ''.html_safe
      actions << @template.link_to('Close', '#close', class: 'btn', data: {dismiss: 'modal'})
      actions << submit(options[:save], disable_with: options[:saving], class: 'btn btn-primary')
    end
  end

  def status options = {}
    options.reverse_merge! success: 'Saved!', error: 'Failed!'
    out = @template.content_tag(:div, class: 'status') do
      status = ''.html_safe
      status << @template.content_tag(:div, '', class: 'spinner')
      # status << @template.content_tag(:div, options[:success], class: 'success')
      # status << @template.content_tag(:div, options[:error], class: 'error')
    end
  end

  def field_wrapper type, name, options = {}
    classes = "field #{type} #{name.to_s.dasherize} form-group"
    classes << options[:classes] if options[:classes]
    classes << ' error' if object.errors.include? name
    options.merge! class: classes
    @template.content_tag :div, options do
      yield
    end
  end

  # def _input_options options
  #   [:autocomplete, :placeholder]
  # end

  def field *args, &block
    type, name, options = _extract_field_args(args)
    out = ''.html_safe

    input_options = {}
    input_args = []
    input_classes = options[:class].try(:split, ' ') || []

    unless options[:autocomplete].nil?
      options.delete(:autocomplete)
      input_options[:autocomplete] = 'off'
    end

    unless options[:placeholder].nil?
      input_options[:placeholder] = if (placeholder = options.delete(:placeholder)) == true then name.to_s.humanize else placeholder end
    end

    unless options[:hidden].nil?
      input_classes << 'hidden' if options[:hidden] == true
    end

    unless options[:required].nil?
      input_options[:required] = 'required' if options[:required] == true
    end

    unless options[:choices].nil?
      input_args << options[:choices]
    end

    out.concat options[:prepend] if options[:prepend]

    label_html = label(name, options[:label], class: "#{LABEL_WIDTH} control-label")

    out.concat label_html if options[:label] && options[:label_first]

    if options[:help_text]
      help_text = send("#{name}_help_text")
      help_html = %Q(<a class="tipsy" title="#{help_text}" href="#">learn more</a>).html_safe
      out.concat help_html
    end

    input_classes << 'form-control'
    input_options[:class] = input_classes.join(' ')

    out.concat(@template.content_tag(:div, class: "#{FIELD_WIDTH} #{type}") do
      merged_input_args = input_args << input_options
      controls = send(_field_types(type), name, *merged_input_args)
      controls.concat @template.content_tag(:div, options[:help_block], class: 'help-block') if options[:help_block].present?
      controls
    end)

    out.concat label_html if options[:label] && !options[:label_first]

    out.concat options[:append] if options[:append]
    out.concat yield if block_given?

    if options[:wrap_field]
      field_wrapper(type, name) { out }
    else
      out
    end
  end

  # simple helper method for extracting and applying default options.
  def _apply_default_options args, defaults
    options = args.extract_options!
    args << options.reverse_merge!(defaults)
  end

  # apply the default options for all fields.
  def _apply_field_defaults args
    _apply_default_options args, field_options.reverse_merge(label: true, wrap_field: true, label_first: true)
  end

  def field_options
    options[:fields] || {}
  end

  # single use method for parsing options provided by the +field+ helper
  def _extract_field_args args
    args = _apply_field_defaults(args)
    options = args.extract_options!
    name = args.pop
    type = args.pop
    options[:label] = name.to_s.humanize if options[:label].is_a? TrueClass
    [type, name, options]
  end

  def _field_types(type)
    case type
    when :string, :location
      :text_field
    when :file
      :file_field
    when :search
      :search_field
    when :text
      :text_area
    when :email
      :email_field
    when :password
      :password_field
    when :hidden, :slider
      :hidden_field
    when :boolean, :radio
      :radio_button
    when :boolean, :check
      :check_box
    when :choices
      :select
    end
  end

  def error_messages
    if object.errors.any?
      @template.render partial: 'shared/form/error_messages', object: object.errors
    end
  end
end

class CMS::FormBuilder
  include CMS::FormBuilder::Fields
end

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  if html =~ /<label/
    html
  else
    message = instance.error_message.map{|m| "#{instance.instance_variable_get(:@method_name).humanize} #{m}"}.join(', ')
    "#{html}<div class=\"help-inline\">#{message}</div>".html_safe
  end
end
