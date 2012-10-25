class Cms::PagesController < ApplicationController
  def show
    @page = params[:page]
  end
end
