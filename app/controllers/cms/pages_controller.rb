class CMS::PagesController < ApplicationController
  def show
    @page = params[:page]
  end

  def static_page
    render "pages/#{params[:page]}"
  end
end
