require 'sinatra'
require 'erb'
require 'json'
require 'pry-byebug'
require 'sinatra/reloader' if development?
require './helpers/blackjack_helpers.rb'

enable :sessions

helpers BlackJackHelpers

before do
  build_deck
end

get '/' do
  erb :home
end

# needs to shuffle deck and deal hands to dealer and player
get '/blackjack' do
  @dealer = deal_cards(2)
  @player = deal_cards(2)
  @player_score = get_player_score(@player)
  @dealer_score = get_player_score(@dealer)
  if @player_score == 21 || @dealer_score == 21
    erb :blackjack_win
  else
    save_variables
    erb :blackjack 
  end
end

post "/blackjack/hit" do
  # adds a card to the players hand and re-renders the main page
  # if hitting would bust player (over 21 total) redirect to get /blackjack/stay
  # need to use cookies/session to keep track of cards already dealt?
  restore_variables
  @player << deal_cards(1).flatten
  puts "#{@player.class}"
  @player_score = get_player_score(@player)
  @dealer_score = get_player_score(@dealer)
  save_variables
  if @player_score >= 21
    redirect to('/blackjack/stay')
  end
  erb :blackjack
end

get '/blackjack/stay' do
  # gets dealer to play their hand - either hit or stay depending on if product is 17 or higher
  # render main page with all cards revealed and describes the result
  restore_variables
  @player_score = get_player_score(@player)
  @dealer_score = get_player_score(@dealer)
  if @player_score > 21
    erb :blackjack_stay
  else
    while @dealer_score <= 17
      @dealer << deal_cards(1).flatten
      @dealer_score = get_player_score(@dealer)
    end
  end
  erb :blackjack_stay
end

get '/blackjack/play_again' do
  redirect to('/blackjack')
end
