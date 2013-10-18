class Cat < ActiveRecord::Base

  before_destroy :delete_files

  default_scope order(:id => :desc)

  def filename
    id.to_s + extname
  end

  def filename_thumb
    '/cats/thumbnails/' + filename
  end

  def filename_full
    '/cats/full/' + filename
  end

  def delete_files
    File.delete Rails.root.join('public', 'cats', 'full', id.to_s + extname)
    File.delete Rails.root.join('public', 'cats', 'thumbnails', id.to_s + extname)
  end

end
