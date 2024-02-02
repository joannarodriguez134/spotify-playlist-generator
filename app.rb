require "sinatra"
require "sinatra/reloader"
require "sinatra/cookies"

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
  @initial_genre = params.fetch("genre")
  @initial_energy = params.fetch("target_energy")
  @initial_instrumentalness = params.fetch("target_instrumentalness")
  @initial_danceability = params.fetch("target_danceability")

  cookies["search_genre"] = @initial_genre
  cookies["search_energy"] = @initial_energy
  cookies["search_instrumentals"] = @initial_instrumentalness
  cookies["search_dance"] = @initial_danceability

  erb(:user_search_results)
end
