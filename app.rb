require 'sinatra'
require 'erb'
require './helpers/hand.rb'
require './helpers/blackjack_helper.rb'
require 'sinatra/reloader' if development?
require 'pry'
require 'json'

enable :sessions
helpers BlackjackHelper

get '/' do
  erb :index
end

get '/blackjack' do
  shuffling = nil
  message = nil
  is_blackjack = false
  set_hand_counter

  if session["deck"] && session["player_hand"]
    current_hand = Hand.new(JSON.parse(session["deck"]), JSON.parse(session["player_hand"]), JSON.parse(session["dealer_hand"]))
  else
    if session["deck"]
      current_hand = Hand.new(JSON.parse(session["deck"]))
    else
      current_hand = Hand.new
    end
    current_hand.deal_cards
    session["deck"] = current_hand.deck.to_json
    session["player_hand"] = current_hand.player_hand.to_json
    session["dealer_hand"] = current_hand.dealer_hand.to_json
    is_blackjack = check_for_blackjacks(current_hand.player_hand,current_hand.dealer_hand)
    if is_blackjack
      message = blackjack_message(current_hand.player_hand,current_hand.dealer_hand)
    end 
  end
  player_hand = current_hand.player_hand
  dealer_hand = current_hand.dealer_hand
  player_sum = ace_changer(player_hand)
  dealer_sum = ace_changer(dealer_hand)
  #check for end of game unless there is a blackjack
  unless is_blackjack
    message = check_hand_end(player_sum, dealer_sum)
  end

  #convert card value to 2 digits
   player_display = convert_hand(player_hand)
   dealer_display = convert_hand(dealer_hand)


  erb :blackjack, :locals =>{:dealer_hand => dealer_display, :player_hand => player_display, :player_sum => player_sum, :dealer_sum => dealer_sum, :message => message, :shuffling => shuffling}

end

  
post '/hit' do
  player_hand = JSON.parse(session["player_hand"])
  dealer_hand = JSON.parse(session["dealer_hand"])
  deck = JSON.parse(session["deck"])
  current_hand = Hand.new(deck, player_hand, dealer_hand)
  current_hand.player_hit(player_hand)
  session["player_hand"] = player_hand.to_json
  session["deck"] = current_hand.deck.to_json

  if ace_changer(player_hand) > 21
    session["player_bust"] = true
  end
  redirect to('/blackjack')
  
end

post '/stand' do
  player_hand = JSON.parse(session["player_hand"])
  dealer_hand = JSON.parse(session["dealer_hand"])
  deck = JSON.parse(session["deck"])
  current_hand = Hand.new(deck,player_hand,dealer_hand)
  until ace_changer(dealer_hand) >= 17
    dealer_hand = current_hand.dealer_hit(dealer_hand)
  end
  hand_complete = false
  dealer_bust = false
  if ace_changer(dealer_hand) > 21
    dealer_bust = true
  else
    hand_complete = true
  end
  session["player_hand"] = player_hand.to_json
  session["dealer_hand"] = dealer_hand.to_json
  session["deck"] = deck.to_json
  session["hand_complete"] = hand_complete
  session["dealer_bust"] = dealer_bust
  redirect to('/blackjack')
end

post '/next_hand' do
  counter = session["hand_counter"].to_i
  if counter+1 == 6
    session["deck"] = nil
    sesssion["hand_counter"] = 1
  end
  delete_cookies
  redirect to('/bet')
end

get '/bet' do
  game_over = false
  #check if there is already a bankroll
  if session["bankroll"]
    bank_remaining = session["bankroll"]
  else
    session["bankroll"] = 1000
    bank_remaining = 1000
  end
  if session["bankroll"] == 0
    game_over = true
  end
  low_funds = nil
  erb :bet, :locals => {:bankroll => bank_remaining, :low_funds => low_funds, :game_over => game_over}
end

post '/bet' do
  game_over = false
  bet_placed = params[:bet].to_i
  bankroll = session["bankroll"].to_i
  if bet_placed > bankroll
    low_funds = true
    erb :bet, :locals => {:low_funds => low_funds, :bankroll => bankroll, :game_over => game_over}
  else
    session["bet_amount"] = bet_placed
    redirect to('/blackjack')
  end
end

get '/reset' do
  session.clear
  redirect to('/bet')
end
