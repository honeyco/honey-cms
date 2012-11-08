module CMS::Helper
  def cms_file name, size = false
    if file = CMS::FileUpload.find_by_name(name) then return file end
    opts = {name: name}
    opts[:description] = (size.sub('x', ' by ') << ' pixels')
    CMS::FileUpload.create(opts, without_protection: true)
  end

  def cms_image name, size = false, width = '', height = ''
    width, height = size.split('x') if size
    image = cms_file(name, size)

    if image.file?
      image_tag image.file.url, class: 'cms-image', style: "width: #{width}px ; height: #{height}px"
    else
      if current_user && current_user.role.admin?
        link_to(name, edit_cms_file_upload_path(image), class: 'cms-image missing-cms-image', style: "width: #{width}px ; height: #{height}px ")
      else
        content_tag :div, name, class: 'cms-image missing-cms-image', style: "width: #{width}px ; height: #{height}px"
      end
    end
  end


  def cms_page_area name, &block
    page_area = if area = CMS::PageArea.find_by_name(name) then area else CMS::PageArea.new({name: name}, without_protection: true) end

    if admin?
      content_tag :div, role: 'html-editor' do
        out = content_tag(:div, class: 'cms-page-area', role: 'display') do
          display  = ''.html_safe
          display << cms_page_area_edit_link if admin?
          display << render_cms_page_area_content(page_area, &block)
        end

        out << content_tag(:div, role: 'editor') do
          form_for([:cms, page_area], format: 'json', remote: true) do |f|
            form  = f.hidden_field(:name)
            form << f.hidden_field(:content, class: 'content')
            form << f.actions(save: 'done')
          end
        end
      end
    else
      content_tag :div, class: 'cms-page-area' do
        render_cms_page_area_content(page_area, &block)
      end
    end
  rescue Exception => e
    if Rails.env.production? then '' else raise e end
  end

  def render_cms_page_area_content page_area, &block
    if page_area.content.present? && !page_area.default
      content = page_area.content
    elsif block_given?
      content = capture(&block)
      page_area.content = ''.concat(content)
      page_area.save!
    end

    content_tag(:div, class: 'content') do
      cms_content_parse(content) if content.present?
    end
  end

  def cms_page_area_edit_link
    content_tag :div, class: 'cms-edit-link' do
      link_to('Edit', '#edit')
    end
  end

  def cms_content_parse content
    CMS::ViewTags.instance.parse content, context: self
  end
end
