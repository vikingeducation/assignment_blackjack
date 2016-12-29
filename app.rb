require 'sinatra'
require 'pry'
require './helpers/blackjack_helper.rb'
require './helpers/deck.rb'
require './helpers/player.rb'

helpers BlackjackHelper

enable :sessions

get '/' do
  deck = Deck.new
  player = Player.new(deck.deal_hand)
  dealer = Player.new(deck.deal_hand)
  save_sessions(deck: deck.cards, 
                player_cards: player.cards, 
                dealer_cards: dealer.cards)
  erb :home
end

get '/bet' do
  erb :bet, locals: { message: nil }
end

post '/bet' do
  deck = Deck.new(load_deck)
  player = Player.new(load_player_cards)
  dealer = Player.new(load_dealer_cards)
  bet = params[:bet].to_i

  if player.valid?(bet)
    save_sessions( { deck: deck.cards, 
                     player_cards: player.cards, 
                     bankroll: player.bankroll, 
                     bet: player.bet, 
                     dealer_cards: dealer.cards } )
    redirect "/blackjack"
  end

  message = "Please place a valid bet."
  erb :bet, locals: { message: message }
end

get '/blackjack' do
  deck = Deck.new(load_deck)
  player = Player.new(load_player_cards, load_bankroll, load_bet)
  dealer = Player.new(load_dealer_cards)

  save_sessions( { deck: deck.cards, 
                   player_cards: player.cards, 
                   bankroll: player.bankroll, 
                   bet: player.bet, 
                   dealer_cards: dealer.cards } )

  erb :blackjack, locals: { player: player, 
                            dealer: dealer, 
                            message: nil }
end

post '/blackjack/hit' do
  deck = Deck.new(load_deck)
  player = Player.new(load_player_cards, load_bankroll, load_bet)
  dealer = Player.new(load_dealer_cards)

  player_hits(player, deck)

  save_sessions( { deck: deck.cards, 
                   player_cards: player.cards, 
                   bankroll: player.bankroll, 
                   bet: player.bet, 
                   dealer_cards: dealer.cards } )

  redirect "/blackjack/stay" if player.sum > 21
  erb :blackjack, locals: { player: player, 
                            dealer: dealer, 
                            message: nil }
end

get '/blackjack/stay' do
  deck = Deck.new(load_deck)
  player = Player.new(load_player_cards, load_bankroll, load_bet)
  dealer = Player.new(load_dealer_cards)

  dealer_hits(dealer, deck)
  message = determine_results(dealer, player)

  save_sessions( { deck: deck.cards, 
                   player_cards: player.cards, 
                   bankroll: player.bankroll, 
                   bet: player.bet, 
                   dealer_cards: dealer.cards } )

  erb :blackjack, locals: { player: player, 
                            dealer: dealer, 
                            message: message }
end



