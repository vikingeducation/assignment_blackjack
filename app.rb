require 'sinatra'
require 'pry-byebug'
require "sinatra/reloader" if development?
require './helpers/game_helper.rb'
require './public/deck.rb'
require './public/player.rb'
require './public/dealer.rb'
require './public/human.rb'
require 'json'

enable :sessions

helpers GameHelper

get '/' do
  erb :home
end

get '/blackjack' do
  initialize_sessions
  @deck = Deck.new( read_deck )
  @player = Player.new( read_player_cards )
  @dealer = Dealer.new( read_dealer_cards )

  if deck_full? @deck
    shuffle_cards @deck, @player
    shuffle_cards @deck, @dealer
  end

  save_deck @deck.cards
  save_dealer_cards @dealer.cards
  save_player_cards @player.cards

  erb :blackjack
end

post '/blackjack/hit' do

  @deck = Deck.new( read_deck )
  @player = Player.new( read_player_cards )

  @deck.deal_card @player

  save_deck @deck.cards
  save_player_cards @player.cards

  redirect to('result') if @player.bust

  redirect to("blackjack")
end

get '/blackjack/stay' do
  @deck = Deck.new( read_deck )
  @dealer = Dealer.new( read_dealer_cards )

  loop do
    break if @dealer.over_17?
    @deck.deal_card @dealer
  end

  save_deck @deck.cards
  save_dealer_cards @dealer.cards
  redirect to("result")
end

get '/result' do
  @deck = Deck.new( read_deck )
  @player = Player.new( read_player_cards )
  @dealer = Dealer.new( read_dealer_cards )
  erb :result
end

post '/new_game' do
  session[:deck] = [].to_json
  session[:player_cards] = [].to_json
  session[:dealer_cards] = [].to_json

  redirect to('blackjack')
end
