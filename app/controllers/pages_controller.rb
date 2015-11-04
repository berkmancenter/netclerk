class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.order( 'RANDOM()' ).limit( 50 )
  end

  def show
    query = NewestStatusFinder.per_country_for_page(@page)
    @cache_key = query.first.try(:created_at).try(:to_i)
    @statuses = query.group_by(&:value).sort_by { |sg| sg[0] }
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      flash[:success] = 'Page created'
      redirect_to @page
    else
      render 'new'
    end
  end

  def update
    if @page.update(page_params)
      flash[:success] = 'Page updated'
      redirect_to @page
    else
      render 'edit'
    end
  end

  def destroy
    @page.destroy
    flash[:success] = 'Page deleted'
    redirect_to pages_path
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:url, :title, :category_id)
  end
end
