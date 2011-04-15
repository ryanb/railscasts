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
    episode.update_attribute(:comments_count, episode.comments.count)
  end
end

desc "Fix the code blocks in all episodes"
task :fix_episodes => :environment do
  Episode.find_each do |episode|
    notes = episode.notes.dup
    notes.gsub!("\r\n", "\n")
    notes.gsub!(/^\/\* (.+) \*\/$|^\<\!\-\- (.+) \-\-\>$|^\# (.+)$|^\/\/ (.+)$/) do |match|
      path = $1 || $2 || $3 || $4
      if path =~ /\.\w+$/ || path =~ /file$/ || path =~ /console$/
        "@@@\n\n@@@ #{path}"
      else
        match
      end
    end
    notes.gsub!("\n\n@@@\n", "\n@@@\n")
    notes.gsub!(/@@@ .+\n@@@\n\n/, "")
    notes.gsub!("@@@", "```")
    notes.gsub!(/\*(\w+?)\*/, '**\1**')
    notes.gsub!("**\n* ", "**\n\n* ")
    notes.gsub!(/"(.+?)"\:(\S+)/, '[\1](\2)')
    notes.gsub!("\n", "\r\n")
    episode.notes = notes
    episode.legacy = true
    episode.save!
  end
end

desc "Mark legacy comments"
task :fix_comments => :environment do
  Comment.update_all(:legacy => true)
end

desc "Fill the episode file size values"
task :episode_file_sizes => :environment do
  Episode.order("position desc").each do |episode|
    episode.load_file_sizes
    sleep 1
    puts "File sizes for episode #{episode.position}: #{episode.file_sizes.inspect}"
    episode.save!
  end
end
