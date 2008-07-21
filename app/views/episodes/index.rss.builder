title = "Railscasts"
author = "Ryan Bates"
description = "Every week you will be treated to a new Railscasts episode featuring tips and tricks with Ruby on Rails, the popular web development framework. These screencasts are short and focus on one technique so you can quickly move on to applying it to your own project. The topics are geared toward the intermediate Rails developer, but beginners and experts will get something out of it as well."
keywords = "rails, ruby on rails, free, screencasts, podcasts, tips, tricks, tutorials, training, programming, railscast"

if params[:ipod]
  title += " (iPod & Apple TV)"
  description += " This version is for the iPod or Apple TV, a full resolution version is also available."
  keywords += ', ipod'
  image = "http://railscasts.com/images/ipod_railscasts_cover.jpg"
  format = 'm4v'
else
  description += " This is the full resolution version, an iPod specific format is also available."
  image = "http://railscasts.com/images/railscasts_cover.jpg"
  format = 'mov'
end


xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",  "xmlns:media" => "http://search.yahoo.com/mrss/",  :version => "2.0" do
  xml.channel do 
    xml.title title
    xml.link 'http://railscasts.com'
    xml.description description
    xml.language 'en'
    xml.pubDate @episodes.first.published_at.to_s(:rfc822)
    xml.lastBuildDate @episodes.first.published_at.to_s(:rfc822)
    xml.itunes :author, author
    xml.itunes :keywords, keywords
    xml.itunes :explicit, 'no'
    xml.itunes :image, :href => image
    xml.itunes :owner do
      xml.itunes :name, author
      xml.itunes :email, 'ryan@railscasts.com'
    end
    xml.itunes :block, 'no'
    xml.itunes :category, :text => 'Technology' do
      xml.itunes :category, :text => 'Software How-To'
    end
    xml.itunes :category, :text => 'Education' do
      xml.itunes :category, :text => 'Training'
    end
 
    xml.media :thumbnail, :url => 'http://railscasts.com'
    xml.media :keywords, keywords
    xml.media :category, {:scheme => "http://www.itunes.com/dtds/podcast-1.0.dtd"}, "Technology/Software How-To"
    xml.media :category, {:scheme => "http://www.itunes.com/dtds/podcast-1.0.dtd"}, "Education/Training"
  
    @episodes.each do  |episode|
      download = episode.downloads.find_by_format(format)
      
      xml.item do
        xml.title episode.name
        xml.description episode.description
        xml.pubDate episode.published_at.to_s(:rfc822)
        xml.enclosure :url => download.url, :length => download.duration, :type => 'video/quicktime'
        xml.link episode_url(episode)
        xml.guid episode_url(episode)
        xml.itunes :author, author
        xml.itunes :subtitle, truncate(episode.description, 150)
        xml.itunes :summary, episode.description
        xml.itunes :explicit, 'no'
        xml.itunes :duration, download.duration
        xml.dc :creator, {"xmlns:dc" => "http://purl.org/dc/elements/1.1/"}, author
        xml.media :content, :url => download.url, :fileSize => download.bytes, :type => 'video/quicktime'
      end
    end
  end
end
