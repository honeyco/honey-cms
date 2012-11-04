class CMS::PagesController < ApplicationController
  def show
    @page = params[:page]
  end
end
