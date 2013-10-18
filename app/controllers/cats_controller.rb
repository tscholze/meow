class CatsController < ApplicationController

  before_filter :login_required, :except => [:index, :show, :random, :feed]

  def index
    @cats = Cat.all.paginate(:page => params[:page])
  end
  
  def show
    @cat = Cat.find(params[:id])
  end

  def destroy
    if session[:user] && session[:user][:can_delete_image]
      cat = Cat.find(params[:id])
      cat.destroy
      redirect_to :action => :index
    else
      render :text => 'permission denied'
    end
  end

  def random
    offset = rand(Cat.count)
    @cat = Cat.offset(offset).first
    render :show
  end

  def feed
    @cats = Cat.order("id DESC").limit(10).load
    respond_to do |format|
      format.html do
        redirect_to :format => :xml
      end
      format.xml do
        render :layout => false
      end
    end
  end

end
