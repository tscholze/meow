class Cat < ActiveRecord::Base
  attr_accessible :extname
  
  def filename
    id.to_s + extname
  end
end
