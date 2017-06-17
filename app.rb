# ./app.rb
require "sinatra"
require 'erb'
require 'pry-byebug'
require './helpers/card_helper.rb'

helpers CardHelper

enable :sessions

get '/' do
  # For each new game, clear any active sessions
  session.clear 
  erb :home
end

get '/setup' do
  # Game starts here
  generate_cards
  
  2.times do
    start_game
  end

  redirect to("blackjack")
end

get '/blackjack' do
  @player_cards = load_cards
  @player_score = load_score

  @dealer_cards = load_dealer_cards
  @dealer_score = load_dealer_score
  @winner = load_winner

  erb :blackjack
end


# If the player hitting would bust that player (bring the total over 21 points), redirect to get /blackjack/stay
post '/blackjack/hit' do
  score = load_score
  puts "player score so far #{score}"
  if !score.nil? && score >= 21
    puts "The player can't play anymore due to scores"
    redirect to("blackjack/stay")
  else
    if deal_if_play_viable
      puts "player has picked an extra card"
      redirect to("blackjack")
    else
      "puts play not viable so switched to dealer"
      redirect to("blackjack/stay")
    end
  end
end

get '/blackjack/stay' do
  result = stay
  puts "the result is #{result}"
  redirect to("blackjack", locals: { winner: result })
end

