require 'sinatra'
require 'erb'
require './blackjack.rb'
require './hand.rb'
require './helpers/blackjack_helper.rb'
require 'sinatra/reloader' if development?
require 'pry'
require 'json'

helpers BlackjackHelper

get '/' do
  erb :index
end

get '/blackjack' do
  #unless request.cookies["deck"]
  #do you have deck if yes play with deck
  # if no create deck cookie that deck
  # deck passed
  shuffling = nil
  bet = request.cookies["bet_amount"].to_i
  bankroll = request.cookies["bankroll"].to_i
  unless request.cookies["hand_counter"]
    response.set_cookie("hand_counter" , 1)
  end

  if request.cookies["deck"] && request.cookies["hand_counter"].to_i < 6
    blackjack = Blackjack.new(JSON.parse(request.cookies["deck"]))
  else
    blackjack = Blackjack.new
    shuffling = true
  end
  if request.cookies["player_hand"]
    current_hand = Hand.new(blackjack.cards, JSON.parse(request.cookies["player_hand"]), JSON.parse(request.cookies["dealer_hand"]))
  else
    current_hand = Hand.new(blackjack.cards)
    current_hand.deal_cards
  end
  player_hand = current_hand.player_hand
  dealer_hand = current_hand.dealer_hand
  player_sum = current_hand.ace_changer(player_hand)
  dealer_sum = current_hand.ace_changer(dealer_hand)

  #check for end of hand
 
  if request.cookies["player_bust"] == "true"
    message = "Player busted"
    response.set_cookie("bankroll",  (bankroll-bet))
  elsif request.cookies["dealer_bust"] == "true"
    message = "You won!"
    response.set_cookie("bankroll",(bankroll+bet))
  elsif request.cookies["hand_complete"] == "true"
    #compare sums
    player_sum = current_hand.ace_changer(player_hand)
    dealer_sum = current_hand.ace_changer(dealer_hand)
    if player_sum > dealer_sum
      message = "You won!"
      response.set_cookie("bankroll",(bankroll+bet))
    elsif dealer_sum > player_sum
      message = "Dealer won."
      response.set_cookie("bankroll",(bankroll-bet))
    else
      message = "It's a push."
    end
  else
    message = nil
  end


  player_display = BlackjackHelper.convert_hand(player_hand)
  dealer_display = BlackjackHelper.convert_hand(dealer_hand)

  response.set_cookie("player_hand", player_hand.to_json)
  response.set_cookie("dealer_hand", dealer_hand.to_json)
  response.set_cookie("deck", blackjack.cards.to_json)
  erb :blackjack, :locals =>{:dealer_hand => dealer_display, :player_hand => player_display, :player_sum => player_sum, :dealer_sum => dealer_sum, :message => message, :shuffling => shuffling}

end

post '/hit' do
  player_hand = JSON.parse(request.cookies["player_hand"])
  dealer_hand = JSON.parse(request.cookies["dealer_hand"])
  deck = JSON.parse(request.cookies["deck"])
  blackjack = Blackjack.new(deck)
  current_hand = Hand.new(blackjack.cards, player_hand, dealer_hand)
  current_hand.player_hit(player_hand)
  response.set_cookie("player_hand", player_hand.to_json)
  response.set_cookie("deck", deck.to_json)

  if current_hand.ace_changer(player_hand) > 21
    response.set_cookie("player_bust", true)
  end
  redirect to('/blackjack')
  
end

post '/stand' do
  player_hand = JSON.parse(request.cookies["player_hand"])
  dealer_hand = JSON.parse(request.cookies["dealer_hand"])
  deck = JSON.parse(request.cookies["deck"])
  blackjack = Blackjack.new(deck)
  current_hand = Hand.new(blackjack.cards,player_hand,dealer_hand)
  until current_hand.ace_changer(dealer_hand) >= 17
    current_hand.dealer_hit(dealer_hand)
  end
  hand_complete = false
  dealer_bust = false
  if current_hand.ace_changer(dealer_hand) > 21
    dealer_bust = true
  else
    hand_complete = true
  end
  response.set_cookie("player_hand", player_hand.to_json)
  response.set_cookie("dealer_hand", dealer_hand.to_json)
  response.set_cookie("deck", deck.to_json)
  response.set_cookie("hand_complete", hand_complete)
  response.set_cookie("dealer_bust", dealer_bust)
  redirect to('/blackjack')
end

post '/next_hand' do
  counter = JSON.parse(request.cookies["hand_counter"])
  response.set_cookie("hand_counter", (counter+1).to_json)
  response.delete_cookie("player_hand")
  response.delete_cookie("dealer_hand")
  response.delete_cookie("player_bust") if request.cookies["player_bust"]
  response.delete_cookie("dealer_bust")
  response.delete_cookie("hand_complete") 
  redirect to('/bet')
end

get '/bet' do

  if request.cookies["bankroll"]
    bank_remaining = request.cookies["bankroll"]
  else
    response.set_cookie("bankroll", 1000)
    bank_remaining = 1000
  end
  low_funds = nil
  erb :bet, :locals => {:bankroll => bank_remaining, :low_funds => low_funds}
end

post '/bet' do

  bet_placed = params[:bet].to_i
  bankroll = request.cookies["bankroll"].to_i
  if bet_placed > bankroll
    low_funds = true
    erb :bet, :locals => {:low_funds => low_funds, :bankroll => bankroll}
  else
    response.set_cookie("bet_amount", bet_placed)
    redirect to('/blackjack')
  end
end
