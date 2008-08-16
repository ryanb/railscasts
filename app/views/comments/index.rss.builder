xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Railscasts Comments"
    xml.description "Recent comments for all Railscasts episodes."
    xml.link formatted_comments_url(:rss)
    
    @comments.each do |comment|
      xml.item do
        xml.title "Comment for Episode #{comment.episode.position}: #{comment.episode.name}"
        xml.description comment.content
        xml.author comment.name
        xml.pubDate comment.created_at.to_s(:rfc822)
        xml.link episode_url(:id => comment.episode, :anchor => dom_id(comment))
        xml.guid({:isPermaLink => "false"}, comment_url(comment))
      end
    end
  end
end
