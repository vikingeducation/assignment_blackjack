require "sinatra"
require "sinatra/reloader" if development?
require "pry"
require_relative "deck"
require "json"
require_relative "./helpers/game_helpers.rb"

helpers GameHelpers

enable :sessions

get "/" do
  erb :home
end

get "/blackjack" do

  if session["deck"]
    deck = JSON.parse(session["deck"])
    player_hand = JSON.parse(session["player_hand"])
    dealer_hand = JSON.parse(session["dealer_hand"])
  else
    deck = Deck.new.deck
    player_hand = []
    dealer_hand = []
    2.times do
      player_hand << deck.pop
      dealer_hand << deck.pop
    end
  end

  message = get_message(player_hand, dealer_hand)
  save_session(deck, player_hand, dealer_hand)

  erb :blackjack, :locals => { player_hand: player_hand, dealer_hand: dealer_hand, player_total: check_hand(player_hand),
    dealer_showing: check_hand(dealer_hand[1..-1]), message: message}
end


post "/blackjack/hit" do
  deck = JSON.parse(session["deck"])
  player_hand = JSON.parse(session["player_hand"])
  player_hand << deck.pop

  session["deck"] = deck.to_json
  session["player_hand"] = player_hand.to_json

  redirect to("blackjack")
end


get "/blackjack/stay" do
  dealer_hand = JSON.parse(session["dealer_hand"])
  deck = JSON.parse(session["deck"])

  until check_hand(dealer_hand) > 16
    dealer_hand << deck.pop
  end
  session["stayed"] = true
  session["deck"] = deck.to_json
  session["dealer_hand"] = dealer_hand.to_json
  redirect to("blackjack")
end


get "/blackjack/reset" do

  session.clear
  redirect to("blackjack")
  
end





