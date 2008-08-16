xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Railscasts Comments for #{@episode.name}"
    xml.description "Comments for Episode #{@episode.position}: #{@episode.name}"
    xml.link formatted_comments_url(:rss)
    
    # REFACTORME some duplication with comments/index.rss.builder
    @episode.comments.recent.each do |comment|
      xml.item do
        xml.title truncate(comment.content, 50)
        xml.description comment.content
        xml.author comment.name
        xml.pubDate comment.created_at.to_s(:rfc822)
        xml.link episode_url(:id => comment.episode, :anchor => dom_id(comment))
        xml.guid({:isPermaLink => "false"}, comment_url(comment))
      end
    end
  end
end
