require "sinatra"
require "sinatra/reloader" if development?
require "pry"
require_relative "deck"
require "json"
require_relative "./helpers/game_helpers.rb"
require "sinatra/cookies"

helpers GameHelpers

enable :sessions

get "/" do
  if request.cookies["bankroll"] != nil
    bankroll = request.cookies["bankroll"]
  else
    response.set_cookie("bankroll", 1000)
    redirect to("/")
  end
  erb :home, :locals => { bankroll: bankroll }
end

get "/blackjack" do
  if session["deck"]
    bet = session["bet"]
    bankroll = request.cookies["bankroll"]
    deck = JSON.parse(session["deck"])
    player_hand = JSON.parse(session["player_hand"])
    dealer_hand = JSON.parse(session["dealer_hand"])
  else
    bankroll = 1000
    response.set_cookie("bankroll", 1000)
    session["bet"] = params["bet"]
    bet = params["bet"]
    deck = Deck.new.deck
    player_hand, dealer_hand = [], []
    2.times do
      player_hand << deck.pop
      dealer_hand << deck.pop
    end
  end

  message = get_message(player_hand, dealer_hand)
  save_session(deck, player_hand, dealer_hand, bet)
  bankroll = update_bankroll(message)

  erb :blackjack, :locals => { player_hand: player_hand, dealer_hand: dealer_hand, player_total: check_hand(player_hand),
    dealer_showing: check_hand(dealer_hand[1..-1]), message: message, bet: bet, bankroll: bankroll }
end


post "/blackjack/hit" do
  hit_player
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
  redirect to("/blackjack")
end


get "/blackjack/reset" do

  session["stayed"] = nil
  session["deck"] = nil
  session["dealer_hand"] = nil
  session["player_hand"] = nil
  session["bet"] = nil
  redirect to("/")

end


# get "/blackjack/split" do
#   
# end


get "/blackjack/double" do

  session["bet"] = session["bet"].to_i * 2
  hit_player
  player_hand = JSON.parse(session["player_hand"])
  if check_hand(player_hand) > 21
    redirect to("/blackjack")
  else
    redirect to("/blackjack/stay")
  end

end
