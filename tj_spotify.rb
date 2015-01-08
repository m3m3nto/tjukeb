# tjukeb: Twitter jukebox bot
# requires mpg123 to play mp3 files
# requires twitter ruby gem

require 'twitter'
require_relative 'lib/support'
require_relative 'lib/play'
require 'rspotify'


client = Twitter::REST::Client.new do |config|
  config.consumer_key    = ""
  config.consumer_secret = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

options = {:result_type => "recent", :count => 1}
latest = ''
last_user = ''
pid = 0

loop do
  puts "Searching..."

  client.search("to:tjukeb", options).take(1).collect do |tweet|
    name = tweet.user.screen_name 
    song_name = tweet.text.gsub("@tjukeb", "").strip

    if !song_name.nil? && song_name != latest
      search = RSpotify::Track.search(song_name)
      
      if search
        Support::DEFAULT_CONFIG[:callbacks] = Spotify::SessionCallbacks.new($session_callbacks)
        session = Support.initialize_spotify!
        play_track(session, search.first.uri.to_s)
        $logger.info "Playing track #{search.first.uri.to_s} until end. Use ^C to exit."
        puts "Playing #{song_name} for #{name}"
        client.update "@#{name} I'm playing #{song_name} for you!"
        Support.poll(session, 0.2, 0) { $end_of_track }
      end
      
    else
        puts "Request not valid: #{song_name}"
    end
    latest = song_name
    
  end
  sleep 10
end
