class CatsController < ApplicationController

  before_filter :login_required, :except => [:index, :show, :random]

  def index
    @cats = Cat.all
  end
  
  def show
    @cat = Cat.find(params[:id])
  end

  def destroy
    cat = Cat.find(params[:id])
    File.delete Rails.root.join('public', 'cats', 'full', cat.id.to_s + cat.extname)
    File.delete Rails.root.join('public', 'cats', 'thumbnails', cat.id.to_s + cat.extname)
    cat.destroy
    redirect_to :action => :index
  end

  def random
    offset = rand(Cat.count)
    cat = Cat.first(:offset => offset)
    redirect_to cat
  end

end
