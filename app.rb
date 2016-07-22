require "sinatra"
require "sinatra/reloader" if development?
require "pry"
require_relative "deck"
require "json"
require_relative "./helpers/game_helpers.rb"
require "sinatra/cookies"

SESSION_VARS = ["player_hand", "dealer_hand", "bet", "deck"]

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
    bet, bankroll = session["bet"], request.cookies["bankroll"]
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
  save_session({ "deck" => deck.to_json, "player_hand" => player_hand.to_json,
                "dealer_hand" => dealer_hand.to_json, "bet" => bet})
  bankroll = update_bankroll(message)

  erb :blackjack, :locals => { player_hand: player_hand,
                               dealer_hand: dealer_hand,
                               player_total: check_hand(player_hand),
                               dealer_showing: check_hand(dealer_hand[1..-1]),
                               message: message, bet: bet, bankroll: bankroll }
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
  save_session( { "stayed" => true, "deck" => deck.to_json, "dealer_hand" =>
                                                        dealer_hand.to_json } )
  redirect to("/blackjack")
end


get "/blackjack/reset" do
  save_session( {"stayed" => nil, "deck" => nil, "dealer_hand" => nil,
                                  "player_hand" => nil, "bet" => nil } )
  redirect to("/")
end

get "/blackjack/double" do
  session["bet"] = session["bet"].to_i * 2
  hit_player
  player_hand = JSON.parse(session["player_hand"])
  get_redirect(player_hand)
end

# get "/blackjack/split" do
#
# end
