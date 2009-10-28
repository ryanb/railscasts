desc "Check if ASCIIcasts are available for episodes."
task :asciicasts => :environment do
  require 'thinking_sphinx' # for some reason this isn't being loaded in the environment
  Episode.all(:conditions => { :asciicasts => false }).each do |episode|
    response = Net::HTTP.get_response(URI.parse("http://asciicasts.com/episodes/#{episode.to_param}"))
    episode.update_attribute(:asciicasts, true) if response.code == "200"
    sleep 3 # so we don't hammer the server
  end
end

desc "Reset position attribute for all comments, sometimes it gets out of sync"
task :reset_comment_positions => :environment do
  Episode.find_each do |episode|
    episode.comments.all(:order => "created_at").each_with_index do |comment, index|
      comment.update_attribute(:position, index+1)
    end
  end
end
