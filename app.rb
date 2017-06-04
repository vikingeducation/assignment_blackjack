# ./app.rb
require "sinatra"
require "sinatra/reloader" if development?
require 'erb'
require 'pry-byebug'
require './helpers/card_helper.rb'

# Register our SecretHelper module so it's available
# here and in our views
helpers CardHelper

enable :sessions


get '/' do
  erb :home
end

get '/blackjack' do
  # Game starts here
  generate_cards
  
  2.times do
    start_game
  end

  @cards = load_cards
  @player_score = load_score

  @cards2 = load_cards2
  @dealer_score = load_score2
  erb :blackjack
end




# post '/blackjack/hit' do
#   deal
#   @cards = load_cards
#   @player_score = load_score

#   # If the player hitting would bust that player (bring the total over 21 points), redirect to get /blackjack/stay
#   redirect to("blackjack/stay")
# end


# triggers the dealer to play his hand (hitting until 17). Once the dealer's hand is finished, render the main page with cards revealed and a message describing the result.
# get '/blackjack/stay'
#   deal2
#   @cards2 = load_cards2
#   @dealer_score = load_score2

#    # Render the template with that secret
#   erb :"blackjack/stay"
# end 