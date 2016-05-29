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
  erb :blackjack, locals: {player: player.cards, dealer: dealer.cards, points: player.total_points, game_over: false}
end

post '/blackjack/hit' do
  deck = get_cards
  player = Player.new(get_player_cards)
  dealer = Dealer.new(get_dealer_cards, deck, player)
  dealer.deal_to_player
  save_state(deck, player.cards, dealer.cards)
  if player.total_points <= 21
    erb :blackjack, locals: {player: player.cards, dealer: dealer.cards, points: player.total_points, game_over: false}
  else
    redirect to('blackjack/busted')
  end
end

post '/blackjack/stay' do
  deck = get_cards
  player = Player.new(get_player_cards)
  dealer = Dealer.new(get_dealer_cards, deck, player)

  player_points = player.total_points
  dealer_points = dealer.get_total(false)

  if dealer_points > 21 || player_points > dealer_points
    message = "You win!"
  elsif dealer_points == player_points
    message = "It's a tie!"
  elsif dealer_points > player_points
    message = "Dealer Wins!"
  end

  erb :blackjack, locals: {player: player.cards, dealer: dealer.cards, points: player.total_points, dealer_points: dealer.total_points, game_over: true, message: message }
end

get '/blackjack/busted' do
  deck = get_cards
  player = Player.new(get_player_cards)
  dealer = Dealer.new(get_dealer_cards, deck, player)
  erb :blackjack, locals: {player: player.cards, dealer: dealer.cards, points: player.total_points, dealer_points: dealer.total_points, game_over: true, message: "You busted!"}
end

post '/blackjack/stay' do
  "you are staying put"
end
