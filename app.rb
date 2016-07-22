require 'sinatra'
require 'erb'
require './blackjack.rb'
require './hand.rb'
require 'sinatra/reloader' if development?
require 'pry'
require 'json'

get '/' do
  erb :index
end

get '/blackjack' do
  #unless request.cookies["deck"]
  #do you have deck if yes play with deck
  # if no create deck cookie that deck
  # deck passed
  if request.cookies["deck"]
    blackjack = Blackjack.new(JSON.parse(request.cookies["deck"]))
  else
    blackjack = Blackjack.new
  end
  if request.cookies["player_hand"]
    current_hand = Hand.new(blackjack.cards, JSON.parse(request.cookies["player_hand"]), JSON.parse(request.cookies["dealer_hand"]))
  else
    current_hand = Hand.new(blackjack.cards)
    current_hand.deal_cards
  end
  player_hand = current_hand.player_hand
  dealer_hand = current_hand.dealer_hand
  player_sum = current_hand.sum_of_cards(player_hand)
  dealer_sum = current_hand.sum_of_cards(dealer_hand)

  #check for end of hand
  if request.cookies["player_bust"]
    message = "Player busted"
  elsif request.cookies["dealer_bust"]
    message = "You won!"
  elsif request.cookies["hand_complete"] 
    #compare sums
    player_sum = current_hand.sum_of_cards(player_hand)
    dealer_sum = current_hand.sum_of_cards(dealer_hand)
    if player_sum > dealer_sum
      message = "You won!"
    else
      message = "Dealer won"
    end
  else
    message = nil
  end

  response.set_cookie("player_hand", player_hand.to_json)
  response.set_cookie("dealer_hand", dealer_hand.to_json)
  response.set_cookie("deck", blackjack.cards.to_json)
  erb :blackjack, :locals =>{:dealer_hand => dealer_hand, :player_hand => player_hand, :player_sum => player_sum, :dealer_sum => dealer_sum, :message => message}

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

  if current_hand.sum_of_cards(player_hand) > 21
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
  until current_hand.sum_of_cards(dealer_hand) > 17
    current_hand.dealer_hit(dealer_hand)
  end
  hand_complete = nil
  dealer_bust = nil 
  if current_hand.sum_of_cards(dealer_hand) > 21
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

# post '/stand' do
#   redirect to('/stand')
# end

