class Cat < ActiveRecord::Base
  
  def filename
    id.to_s + extname
  end

  def filename_thumb
    '/cats/thumbnails/' + filename
  end
  
  def filename_full
    '/cats/full/' + filename
  end
end
