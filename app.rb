require 'sinatra'
require 'json'
require './helpers/blackjack_helpers'
require './deck'
require './dealer'
require './player'

helpers BlackjackHelpers

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  deck = Deck.new.deck
  player = Player.new
  dealer = Dealer.new([], deck, player)
  dealer.deal
  save_deck(deck)
  save_players_cards(player.hand)
  save_dealers_cards(dealer.hand)
  erb :blackjack, locals: {players_cards: player.hand, dealers_cards: dealer.hand, player_finished: false, player_total: player.get_player_total}
end

post '/blackjack/hit' do
  deck = load_deck
  player = Player.new(load_players_cards)
  dealer = Dealer.new(load_dealers_cards, deck, player)
  dealer.deal_card_to_player
  save_deck(deck)
  save_players_cards(player.hand)
  save_dealers_cards(dealer.hand)
  if player.get_player_total[0] <= 21
    erb :blackjack, locals: {players_cards: player.hand, dealers_cards: dealer.hand, player_finished: false, player_total: player.get_player_total}
  else
    redirect to('blackjack/busted')
  end
end

post '/blackjack/stand' do
  deck = load_deck
  player = Player.new(load_players_cards)
  dealer = Dealer.new(load_dealers_cards, deck, player)

  # At this point in time, we know that payer can't make any more decisions so I want that to be a set number as well. if player_total.size == 2, player_total = player_total[1] else player_total = player_total[0]
  player_total = player.get_highest_total

  # Because doesn't have to make a decision once a number has been reached. if dealer_total.size == 2 and dealer_total[1] >= 17, dealer_total = dealer_total[1].
  # We can also use this number to figure out whether we want to keep drawing cards or not.
  dealer_total = dealer.get_highest_total

  until dealer_total >= 17
    dealer.deal_card_to_dealer
    dealer_total = dealer.get_highest_total
  end

  if dealer_total > 21
    outcome = "Dealer Busts, You Win!"
  elsif dealer_total == player_total
    outcome = "Push"
  elsif dealer_total > player_total
    outcome = "Dealer Wins"
  else
    outcome = "You Win"
  end

  erb :blackjack, locals: {players_cards: player.hand, dealers_cards: dealer.hand, player_finished: true, player_total: player_total, dealer_total: dealer_total,
    outcome: outcome}
end

get '/blackjack/busted' do
  player = Player.new(load_players_cards)
  dealer = Dealer.new(load_dealers_cards, load_deck, player)
  erb :blackjack, locals: {players_cards: player.hand, dealers_cards: dealer.hand, player_finished: true, dealer_total: dealer.get_dealer_total, outcome: "YOU BUSTED!", player_total: player.get_player_total}
end