require "sinatra"
require "sinatra/reloader"
require "sinatra/cookies"
require "http"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb :)</p>
  "
end


get("/search_form") do
  erb(:user_search_form)

end

get("/search_results") do
  # using the names from the input to create instance variables 
  @initial_genre = params.fetch("genre", "rock") # Default value is "rock" if no genre provided because it allows the url to be built upon that
  @initial_energy = params.fetch("target_energy")
  @initial_instrumentalness = params.fetch("target_instrumentalness")
  @initial_danceability = params.fetch("target_danceability")

  cookies["search_genre"] = @initial_genre
  cookies["search_energy"] = @initial_energy
  cookies["search_instrumentals"] = @initial_instrumentalness
  cookies["search_dance"] = @initial_danceability

  # unlike initial_genre, this is used for the url and replaces commas and spaces for more than one genre
  @user_seed_genres = @initial_genre.gsub(",", "%2C").gsub(" ", "+")

  # spotify credentials from spotify api app
  my_spotify_client_id = ENV.fetch("SPOTIFY_CLIENT_ID")
  my_spotify_client_secret = ENV.fetch("SPOTIFY_CLIENT_SECRET")

  # Build the Spotify URL dynamically based on user input
  spotify_url = "https://api.spotify.com/v1/recommendations?seed_genres=#{@user_seed_genres}"
  spotify_url += "&target_danceability=#{@initial_danceability}" if !@initial_danceability.empty?
  spotify_url += "&target_energy=0.7" if !@initial_energy.empty?
  spotify_url += "&target_instrumentalness=#{@initial_instrumentalness}" if !@initial_instrumentalness.empty?


  access_token = ENV.fetch("ACCESS_TOKEN")


  # Make the API request to Spotify with the access token
  response = HTTP.headers("Authorization" => "Bearer #{access_token}").get(spotify_url)
  
  # Check if the response is successful (status code 200)
  if response.code == 200
    @raw_response = response.to_s
    @parsed_response = JSON.parse(@raw_response)

    @tracks_array = @parsed_response.fetch("tracks") # 20

    @tracks_array_one = @tracks_array[0]
    @artist_one_hash = @tracks_array_one.fetch("artists")
    @artist_one_array = @artist_one_hash[0]
    @artist_one_name = @artist_one_array["name"]

    @artist_one_song_name = @tracks_array_one.fetch("name")



   

    @tracks_array_two = @tracks_array[1]

    @tracks_array_three = @tracks_array[2]
  
    


    
    erb(:user_search_results)
  else
    # Handle error response from Spotify
    @error_message = "Error: #{response.code} - #{response.body}"

  erb(:user_search_results)
  end
end
