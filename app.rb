require 'sinatra'
require 'pry'
require './helpers/blackjack_helper.rb'
require './helpers/deck.rb'
require './helpers/player.rb'

helpers BlackjackHelper

enable :sessions

get '/' do
  deck = Deck.new
  player_hand = Player.new(deck.deal_hand)
  dealer_hand = Player.new(deck.deal_hand)
  save_sessions(deck: deck.cards, 
                player_cards: player_hand.cards, 
                dealer_cards: dealer_hand.cards)
  erb :home
end

get '/bet' do
  erb :bet, locals: { message: nil }
end

post '/bet' do
  deck = Deck.new(load_deck)
  player_hand = Player.new(load_player_hand)
  dealer_hand = Player.new(load_dealer_hand)
  bet = params[:bet].to_i

  if player_hand.valid?(bet)
    save_sessions( { deck: deck.cards, 
                     player_cards: player_hand.cards, 
                     bankroll: player_hand.bankroll, 
                     bet: player_hand.bet, 
                     dealer_cards: dealer_hand.cards } )
    redirect "/blackjack"
  end

  message = "Please place a valid bet."
  erb :bet, locals: { message: message }
end

get '/blackjack' do
  deck = Deck.new(load_deck)
  player_hand = Player.new(load_player_hand, load_bankroll, load_bet)
  dealer_hand = Player.new(load_dealer_hand)

  save_sessions( { deck: deck.cards, 
                   player_cards: player_hand.cards, 
                   bankroll: player_hand.bankroll, 
                   bet: player_hand.bet, 
                   dealer_cards: dealer_hand.cards } )

  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: nil, 
                            player_sum: nil, 
                            dealer_sum: nil,
                            bankroll: player_hand.bankroll }
end

post '/blackjack/hit' do
  deck = Deck.new(load_deck)
  player_hand = Player.new(load_player_hand, load_bankroll, load_bet)
  dealer_hand = Player.new(load_dealer_hand)

  player_hits(player_hand, deck)

  save_sessions( { deck: deck.cards, 
                   player_cards: player_hand.cards, 
                   bankroll: player_hand.bankroll, 
                   bet: player_hand.bet, 
                   dealer_cards: dealer_hand.cards } )

  redirect "/blackjack/stay" if player_hand.sum > 21
  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: nil, 
                            player_sum: nil, 
                            dealer_sum: nil,
                            bankroll: player_hand.bankroll }
end

get '/blackjack/stay' do
  deck = Deck.new(load_deck)
  player_hand = Player.new(load_player_hand, load_bankroll, load_bet)
  dealer_hand = Player.new(load_dealer_hand)

  dealer_hits(dealer_hand, deck)
  message = determine_results(dealer_hand, player_hand)

  save_sessions( { deck: deck.cards, 
                   player_cards: player_hand.cards, 
                   bankroll: player_hand.bankroll, 
                   bet: player_hand.bet, 
                   dealer_cards: dealer_hand.cards } )

  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: message,
                            player_sum: player_hand.sum, 
                            dealer_sum: dealer_hand.sum,
                            bankroll: player_hand.bankroll }
end



