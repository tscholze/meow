class CatsController < ApplicationController

  def index
    @cats = Cat.all
  end
  
  def show
    @cat = Cat.find(params[:id])
  end

  def random
    offset = rand(Cat.count)
    cat = Cat.first(:offset => offset)
    redirect_to cat
  end

end
