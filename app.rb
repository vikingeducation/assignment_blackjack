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

# post '/secret' do
#   # Save our new secret using our helper method, which
#   # returns the secret text as well
#   @secret_text = save_secret( params[:secret_text] )

#   # Redirect us to the secret showing page (get '/secret')
#   redirect to("secret")
# end


#   # If the player hitting would bust that player (bring the total over 21 points), redirect to get /blackjack/stay
#   redirect to("blackjack/stay")
# end
post '/blackjack/hit' do
  # params[:hit]
  score = load_score
  puts "player score so far #{score}"
  if !score.nil? && score >= 21
    puts "The player can't play anymore due to scores"
    redirect to("blackjack/stay")
  else
    if deal_if_play_viable
      puts "player has picked a card"
      redirect to("blackjack")
    else
      redirect to("blackjack/stay")
    end
  end

  # erb :"secret/new"
  # @cards = load_cards
  # @player_score = load_score
end

# post '/blackjack/hit' do
#   @cards = load_cards
#   @player_score = load_score
# end


get '/blackjack/stay' do
  @dealer_cards = load_dealer_cards
  @dealer_score = load_dealer_score
  redirect to("blackjack")
end


# triggers the dealer to play his hand (hitting until 17). Once the dealer's hand is finished, render the main page with cards revealed and a message describing the result.
# get '/blackjack/stay'
#   deal2
#   @cards2 = load_cards2
#   @dealer_score = load_score2

#    # Render the template with that secret
#   erb :"blackjack/stay"
# end 