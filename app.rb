require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'pry'

require './helpers/blackjack_helper.rb'
require './public/assets/carddeck.rb'
require './public/assets/player.rb'
require './public/assets/dealer.rb'

helpers BlackjackHelper

enable :sessions

get '/blackjack' do
  load_deck
  load_player
  load_dealer
  @deck = CardDeck.new(JSON.parse(session[:deck]))
  @player = Player.new(JSON.parse(session[:player]))
  @dealer = Dealer.new(JSON.parse(session[:dealer]))

  2.times {|turn|
    @deck.take_card(@player)
    @deck.take_card(@dealer)
  } if @dealer.hand.empty? || @player.hand.empty?

  @player.hand_sum
  @dealer.hand_sum

  save_deck(@deck)
  save_player(@player)
  save_dealer(@dealer)

  erb :"blackjack.html"
end

post '/blackjack/hit' do
  @deck = CardDeck.new(JSON.parse(session[:deck]))
  @player = Player.new(JSON.parse(session[:player]))

  @deck.take_card(@player)

  save_deck(@deck)
  save_player(@player)

  redirect '/blackjack'
end

get '/blackjack/stay' do
  @deck = CardDeck.new(JSON.parse(session[:deck]))
  @dealer = Dealer.new(JSON.parse(session[:dealer]))
  binding.pry
  while @dealer.required_hit do
    @deck.take_card(@dealer)
  end

  save_deck(@deck)
  save_dealer(@dealer)

  redirect '/blackjack'
end

get '/blackjack/results' do
  @deck = CardDeck.new(JSON.parse(session[:deck]))
  @player = Player.new(JSON.parse(session[:player]))
  @dealer = Dealer.new(JSON.parse(session[:dealer]))

  erb :"results.html"
end




