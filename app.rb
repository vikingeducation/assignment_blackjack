# ./app.rb
require "sinatra"
# require "sinatra/reloader" if development?
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

  @player_cards = load_cards
  @player_score = load_score

  @dealer_cards = load_dealer_cards
  @dealer_score = load_dealer_score
  erb :blackjack
end

get '/blackjack/hit' do
  score = load_score
  puts "player score so far #{score}"
  if !score.nil? && score >= 21
    redirect to("blackjack/stay")
  else
    result = deal_if_play_viable
    if result == "not viable"
      redirect to("blackjack/stay")
    else
       redirect to("blackjack")
     end
  end
  # @cards = load_cards
  # @player_score = load_score
end

post '/blackjack/hit' do
  @cards = load_cards
  @player_score = load_score
end

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