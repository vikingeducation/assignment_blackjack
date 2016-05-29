require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
require 'pry-byebug'
require_relative './helpers/blackjack.rb'
require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

enable :sessions

helpers BJHelpers

get '/' do
  erb :index
end

get '/blackjack' do
  deck = Deck.new.deck
  player = Player.new
  dealer = Dealer.new([], deck, player)
  dealer.deal_cards
  save_state(deck, player.cards, dealer.cards)
  erb :blackjack, locals: {player: player.cards, dealer: dealer.cards}
end

post '/blackjack/hit' do
  deck = get_cards
  player = Player.new(get_player_cards)
end

post '/blackjack/stay' do
  "you are staying put"
end
