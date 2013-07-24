namespace :cats do
  
  require "RMagick"
  require "fileutils"

  def create_preview_images(file)
    img = Magick::Image.read(Rails.root.join('public', 'cats', 'full', file)).first
    rmagick_resize(img, 200, Rails.root.join('public', 'cats', 'thumbnails', file))
  end

  def rmagick_resize(img, max_x, filename)
    x = img.columns
    y = img.rows
    ratio = (1.0 * x) / y
    new_x = max_x
    new_y = max_x / ratio
    img_new = img.resize(new_x, new_y)
    img_new.write(filename)
  end
  
  desc "Import images from filesystem"
  task :import => :environment do
    puts 'import from filesystem ...'
    Dir.foreach(Rails.root.join('public', 'cats', 'import')) do |f|
      if /\.(gif|png|jpe?g)$/.match(f)
        filepath = Rails.root.join('public', 'cats', 'import', f)
        filename = File.basename(f)
        extname  = File.extname(f)
        cat = Cat.create(:extname => extname)
        new_filename = cat.id.to_s + cat.extname
        # move original image to full folder
        FileUtils.mv filepath, Rails.root.join('public', 'cats', 'full', new_filename)
        # create thumbnail
        begin
          create_preview_images(new_filename)
        rescue Exception => e
          puts "error creating preview image of #{new_filename} (exception: #{e}), copying full version to thumnails folder"
          FileUtils.cp Rails.root.join('public', 'cats', 'full', new_filename), Rails.root.join('public', 'cats', 'thumbnails', new_filename)
        end
      end
    end
  end
  
end
