description = "Every week you will be treated to a new RailsCasts episode featuring tips and tricks with Ruby on Rails, the popular web development framework. These screencasts are short and focus on one technique so you can quickly move on to applying it to your own project. The topics are geared toward the intermediate Rails developer, but beginners and experts will get something out of it as well."

xml.rss :version => "2.0" do
  xml.channel do
    xml.title "RailsCasts Recent Comments"
    xml.link 'http://railscasts.com/comments'
    xml.description "Recent comments to all RailsCasts"
    xml.language 'en'
    xml.pubDate @comments.first.updated_at.to_s(:rfc822)
    xml.lastBuildDate @comments.first.updated_at.to_s(:rfc822)

    @comments.each do |comment|
      xml.item do
        xml.title "Comment by #{comment.user.name} on Episode #{comment.episode.full_name}"
        xml.description comment.content
        xml.pubDate comment.updated_at.to_s(:rfc822)
        xml.guid({:isPermaLink => "false"}, "comment-#{comment.id}-#{comment.updated_at.to_i}")
        xml.link episode_url(comment.episode, :view => "comments", :anchor => "comment_#{comment.id}") 
      end
    end
  end
end
