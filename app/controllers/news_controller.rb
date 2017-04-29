class NewsController < ApplicationController
  def index
    @news = News.page(params[:page]).order('created_at DESC').all
  end

  def show
    @entry = News.find(params[:id])
  end
end
