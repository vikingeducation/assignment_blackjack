require_relative './hand.rb'
require_relative './blackjack.rb'

module BlackjackHelper

CONVERSIONS = {"11" => "J", "12" => "Q", "13" => "K", "1" => "A"}

def convert_hand(hand)
  cards = hand.map do |card|
      if CONVERSIONS[card.to_s]
        CONVERSIONS[card.to_s]
      else
        card
      end
  end
end

def set_hand_counter
  unless request.cookies["hand_counter"]
    response.set_cookie("hand_counter" , 1)
  end
end

def check_for_blackjacks(hand_1, hand_2)
  is_blackjack?(hand_1) || is_blackjack?(hand_2)
end

def blackjack_message(hand_1,hand_2)
  bet = request.cookies["bet_amount"].to_i
  bankroll = request.cookies["bankroll"].to_i
  if is_blackjack?(hand_1) && is_blackjack?(hand_2)
    message = "Dealer and player both have blackjacks - It's a push"
  elsif is_blackjack?(hand_1)
    message = "You got blackjack!"
    response.set_cookie("bankroll",(bankroll+(1.5*bet)))
  else
    message = "Dealer got blackjack"
    response.set_cookie("bankroll", bankroll-bet)
  end
  message
end

def is_blackjack?(hand)
  ace_changer(hand) == 21
end

#Aces considered 11 for now
def sum_of_cards(hand)
  card_values = hand.map do |card|
    if card == 1
      card = 11
    elsif card >= 11
      card = 10
    else
      card
    end
  end
  card_values.reduce(:+)
end

def ace_changer(hand)
  hand_sum = sum_of_cards(hand)
  if hand.include?(1) && hand_sum > 21
    hand_sum -= 10
  end
  hand_sum
end

def check_hand_end(player_sum, dealer_sum)
  bet = request.cookies["bet_amount"].to_i
  bankroll = request.cookies["bankroll"].to_i
  if request.cookies["player_bust"] == "true"
    message = "Player busted"
    response.set_cookie("bankroll",  (bankroll-bet))
  elsif request.cookies["dealer_bust"] == "true"
    message = "You won!"
    response.set_cookie("bankroll",(bankroll+bet))
  elsif request.cookies["hand_complete"] == "true"
    #compare sums
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
  message
end

def delete_cookies
  response.delete_cookie("player_hand")
  response.delete_cookie("dealer_hand")
  response.delete_cookie("player_bust") if request.cookies["player_bust"]
  response.delete_cookie("dealer_bust")
  response.delete_cookie("hand_complete")
end

end
# A 6  total = 7 or 17
# A 3 K total = 14 

#
#
#