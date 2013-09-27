namespace :cats do
  
  require "RMagick"
  require "fileutils"
  require "pathname"

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
  
  desc "Download images from all linked dropbox accounts"
  task :download_dropbox => :environment do
    puts 'download images from dropbox'
    users = User.where.not(:dropbox_user_id => nil)
    users.each do |u|
      puts "using dropbox account of user #{ u.login }"
      client = DropboxClient.new(u.dropbox_access_token)
      # puts client.account_info.to_yaml
      results = client.metadata('Meow')
      results['contents'].each do |content|
        if /\.(gif|png|jpe?g)$/.match(content['path'])
          file_content = client.get_file(content['path'])
          File.open(Rails.root.join('public', 'cats', 'import', Pathname.new(content['path']).basename), 'wb') { |file| file.write(file_content) }
        end
      end
    end
    Rake::Task["cats:import"].invoke
  end
  
  desc "Import images from filesystem"
  task :import => :environment do
    puts 'import from filesystem ...'
    Dir.foreach(Rails.root.join('public', 'cats', 'import')) do |f|
      if /\.(gif|png|jpe?g)$/.match(f)
        filepath = Rails.root.join('public', 'cats', 'import', f)
        filename = File.basename(f)
        extname  = File.extname(f)
        checksum = Digest::MD5.file(filepath).to_s
        # check if image with same checksum already exist
        check = Cat.where(:checksum => checksum)
        if check.length == 0
          cat = Cat.create({ :extname => extname, :checksum => checksum })
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
        else
          puts "there's already a image with the checksum #{ checksum }, ignoring #{ filename } "
          File.delete filepath
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
