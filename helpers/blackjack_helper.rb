module BlackjackHelper

CONVERSIONS = {"11" => "J", "12" => "Q", "13" => "K", "1" => "A"}

def convert_hand(hand)
  cards = hand.map do |card|
     [('%02d' % card[0]),card[1]]
  end
end

def set_hand_counter
  unless session["hand_counter"]
    session["hand_counter"] = 1
  end
end

def check_for_blackjacks(hand_1, hand_2)
  is_blackjack?(hand_1) || is_blackjack?(hand_2)
end

def blackjack_message(hand_1,hand_2)
  bet = session["bet_amount"].to_i
  bankroll = session["bankroll"].to_i
  if is_blackjack?(hand_1) && is_blackjack?(hand_2)
    message = "Dealer and player both have blackjacks - It's a push"
  elsif is_blackjack?(hand_1)
    message = "You got blackjack!"
    session["bankroll"] = bankroll+(1.5*bet)
  else
    message = "Dealer got blackjack"
    session["bankroll"] = bankroll-bet
  end
  message
end

def is_blackjack?(hand)
  ace_changer(hand) == 21
end

#each card is an array such as [5, "c"]
def sum_of_cards(hand)
  card_values = hand.map do |card|
    if card[0] >= 11
      10
    elsif card[0] == 1
      11
    else
      card[0]
    end
  end
  card_values.reduce(:+)
end

def ace_changer(hand)
  hand_sum = sum_of_cards(hand)
  if has_card?(hand,1) && hand_sum > 21
    hand_sum -= 10
  end
  hand_sum
end

def has_card?(hand, value)
  values = []
  hand.each do |card|
    values << card[0]
  end
  values.include?(value)
end

def check_hand_end(player_sum, dealer_sum)
  bet = session["bet_amount"].to_i
  bankroll = session["bankroll"].to_i
  if session["player_bust"] == true
    message = "You busted"
    session["bankroll"] = bankroll-bet
  elsif session["dealer_bust"] == true
    message = "You won!"
    session["bankroll"] = bankroll+bet
  elsif session["hand_complete"] == true
    #compare sums
    if player_sum > dealer_sum
      message = "You won!"
      session["bankroll"]= bankroll+bet
    elsif dealer_sum > player_sum
      message = "Dealer won."
      session["bankroll"] = bankroll-bet
    else
      message = "It's a push."
    end
  else
    message = nil
  end
  message
end

def delete_cookies
  session["player_hand"] = nil
  session["dealer_hand"] = nil
  session["player_bust"] = nil if session["player_bust"]
  session["dealer_bust"] = nil
  session["hand_complete"] = nil
end

end