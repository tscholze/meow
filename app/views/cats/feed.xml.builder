xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Meow!'
    xml.description 'A lot of cats.'
    xml.link "#{request.protocol}#{request.host_with_port}"
    
    for cat in @cats
      xml.item do
        xml.title "Cat ##{cat.id}"
        xml.description link_to((image_tag "#{request.protocol}#{request.host_with_port}#{cat.filename_thumb}"), cat_url(cat))
        xml.pubDate cat.created_at.to_s(:rfc822)
        xml.link cat_url(cat)
        xml.guid cat_url(cat)
      end
    end
  end
end
