class CMS::<%= @name.pluralize %>Controller < CMS::BaseController
  helper_method :subject

  protected

  def subject
    CMS::<%= @name %>
  end
end
