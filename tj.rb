# tjukeb: Twitter jukebox bot
# requires mpg123 to play mp3 files
# requires twitter ruby gem

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key    = ""
  config.consumer_secret = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

PATH = "./music" ##insert path to your mp3 directory

list = Dir["#{PATH}/**/*.mp3"].map{|f| File.basename(f, ".mp3")}
options = {:result_type => "recent", :count => 1}
latest = ''
last_user = ''
pid = 0

loop do
  puts "Searching..."

  client.search("to:tjukeb", options).take(1).collect do |tweet|
    name = tweet.user.screen_name 

    if tweet.text.include?("playlist") && last_user != name
      puts "Sending playlist to #{name}"
      client.update "@#{name} Songs list: #{list.join(", ")}"
      last_user = name
    else
      song_name = tweet.text.gsub("@tjukeb", "").strip

      if !song_name.nil? && list.include?(song_name) && song_name != latest
        puts "Playing #{song_name} for #{name}"
        song_path = "#{PATH}/#{song_name}.mp3"
        client.update "@#{name} I'm playing #{song_name} for you!"
        if File.exist?(song_path)
          if pid > 0
            puts "killing #{pid}"
            `kill -9 #{pid}`
          end
          pid = fork{ exec 'mpg123','-q', song_path }
        end
      else
        puts "Request not valid: #{song_name}"
      end
      latest = song_name
    end
  end
  sleep 10
end
