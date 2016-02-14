=begin
  3. Refactor for OOP

  Now that you've gotten the application working, refactor it into good object-oriented code. That means using objects and classes wherever possible. Remember that imported classes will not have access to the session or cookies!

  Your best option is to (re)instantiate the class by passing the necessary session/cookie information up front (e.g. Player.new(:bankroll => session["bankroll"])) and storing it in the instance variables for use during the current HTTP request.
=end

require 'sinatra'
require 'json'
require './helpers/blackjack_helpers'
require './deck'

helpers BlackjackHelpers

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  deck = Deck.new.deck
  players_cards = []
  dealers_cards = []
  players_cards << deck.pop
  dealers_cards << deck.pop
  players_cards << deck.pop
  dealers_cards << deck.pop
  save_deck(deck)
  save_players_cards(players_cards)
  save_dealers_cards(dealers_cards)
  erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: false, player_total: get_player_total}
  # No shortcuts!!
  # You know what, we gotta save these to the sessions
  # To do that we need to use sessions and JSON
end

post '/blackjack/hit' do
  deck = load_deck
  players_cards = load_players_cards
  dealers_cards = load_dealers_cards
  players_cards << deck.pop
  save_deck(deck)
  save_players_cards(players_cards)
  save_dealers_cards(dealers_cards)
  if get_player_total[0] <= 21
    erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: false, player_total: get_player_total}
  else
    redirect to('blackjack/busted')
  end
end

post '/blackjack/stand' do
  deck = load_deck
  players_cards = load_players_cards
  dealers_cards = load_dealers_cards

  # At this point in time, we know that payer can't make any more decisions so I want that to be a set number as well. if player_total.size == 2, player_total = player_total[1] else player_total = player_total[0]
  if get_player_total.size == 2
    player_total = get_player_total[1]
  else
    player_total = get_player_total[0]
  end

  # Because doesn't have to make a decision once a number has been reached. if dealer_total.size == 2 and dealer_total[1] >= 17, dealer_total = dealer_total[1].
  # We can also use this number to figure out whether we want to keep drawing cards or not.
  if get_dealer_total.size == 2
    dealer_total = get_dealer_total[1]
  else
    dealer_total = get_dealer_total[0]
  end

  until dealer_total >= 17
    dealers_cards << deck.pop
    save_dealers_cards(dealers_cards)
    if get_dealer_total.size == 2
      dealer_total = get_dealer_total[1]
    else
      dealer_total = get_dealer_total[0]
    end
  end

  # if the dealer_total[0] >= 21 message = dealer busts, you win
  # if the dealer_total[0] or [1] > player_total[0] or [1] message = dealer wins
  # if the dealer_total is less than that playesrs = message = you win
  # if the dealer total and the player_total are the same than the message = "push"
  if dealer_total > 21
    outcome = "Dealer Busts, You Win!"
  elsif dealer_total == player_total
    outcome = "Draw"
  elsif dealer_total > player_total
    outcome = "Dealer Wins"
  else
    outcome = "You Win"
  end

  erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: true, player_total: player_total, dealer_total: dealer_total,
    outcome: outcome}
end

get '/blackjack/busted' do
  players_cards = load_players_cards
  dealers_cards = load_dealers_cards
  erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: true, dealer_total: get_dealer_total, outcome: "YOU BUSTED!", player_total: get_player_total}
end