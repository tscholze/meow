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
  
  desc "Calculate the checksum for existing images"
  task :generate_checksum => :environment do
    puts 'calculating checksum for existing cats'
    cats = Cat.where(:checksum => nil)
    cats.each do |cat|
      filename_full = Rails.root.join('public', cat.filename_full[1..-1])
      # puts filename_full
      checksum = Digest::MD5.file(filename_full)
      puts "#{ cat.filename } => #{ checksum.to_s }"
      cat.update_attributes!({ :checksum => checksum.to_s })
    end
  end
  
  desc "Find duplicates by using md5 checksum"
  task :find_duplicates => :environment do
    cats = Cat.group("checksum").having("count(checksum) > 1")
    cats.each do |cat|
      duplicates = Cat.where(:checksum => cat.checksum).where.not(:id => cat.id)
      puts "found #{ duplicates.length } duplicates for cat with id #{ cat.id }"
      duplicates.destroy_all
    end
  end
  
end
