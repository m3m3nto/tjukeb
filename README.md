tjukeb
======

Ultra basic twitter jukebox app.

##Setup

Edit tj.rb with your Twitter api keys:

* consumer_key
* consumer_secret
* access_token
* access_token_secret

and specify your music directory

`
PATH = "/path/to/your/music-directory"
`

##Execution

Move to application location and:

`
ruby tj.rb
`

##Available commands

1. Sends the list of avaible songs in the music directory:

@your-twitter-account playlist

results: tjukeb send you a mention with the playlist


2. Plays a song

@your-twitter-account song-name

results: tjukeb plays the song and sen you a mention saying that