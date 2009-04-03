desc "Check if ASCIIcasts are available for episodes."
task :asciicasts => :environment do
  require 'thinking_sphinx' # for some reason this isn't being loaded in the environment
  Episode.all(:conditions => { :asciicasts => false }).each do |episode|
    response = Net::HTTP.get_response(URI.parse("http://asciicasts.com/episodes/#{episode.to_param}"))
    episode.update_attribute(:asciicasts, true) if response.code == "200"
    sleep 3 # so we don't hammer the server
  end
end
