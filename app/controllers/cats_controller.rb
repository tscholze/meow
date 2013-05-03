class CatsController < ApplicationController

  before_filter :login_required, :except => [:index, :show, :random, :feed]

  def index
    @cats = Cat.all
  end
  
  def show
    @cat = Cat.find(params[:id])
  end

  def destroy
    if session[:user] && session[:user][:can_delete_image]
      cat = Cat.find(params[:id])
      File.delete Rails.root.join('public', 'cats', 'full', cat.id.to_s + cat.extname)
      File.delete Rails.root.join('public', 'cats', 'thumbnails', cat.id.to_s + cat.extname)
      cat.destroy
      redirect_to :action => :index
    else
      render :text => 'permission denied'
    end
  end

  def random
    offset = rand(Cat.count)
    @cat = Cat.first(:offset => offset)
    render :show
  end

  def feed
    @cats = Cat.order("id DESC").limit(10).all
    respond_to do |format|
      format.xml { render :layout => false  } # feed.xml.builder
    end
  end

end
