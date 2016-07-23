module BlackjackHelper

CONVERSIONS = {"11" => "J", "12" => "Q", "13" => "K", "1" => "A"}

def self.convert_hand(hand)
  cards = hand.map do |card|
      if CONVERSIONS[card.to_s]
        CONVERSIONS[card.to_s]
      else
        card
      end
  end
end

def self.set_hand_counter
  unless request.cookies["hand_counter"]
    response.set_cookie("hand_counter" , 1)
  end
end

def self.check_hand_end
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
  message
end

def self.delete_cookies
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