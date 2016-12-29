module BlackjackHelper

  def load_player_hand
    session[:player_hand]
  end

  def load_dealer_hand
    session[:dealer_hand]
  end

  def load_deck
    session[:deck]
  end
   
  def save_player_hand(hand)  
    session[:player_hand] = hand
  end

  def save_dealer_hand(hand)  
    session[:dealer_hand] = hand
  end

  def save_deck(deck)
    session[:deck] = deck
  end

  def dealer_hits(dealer_hand, deck)
    dealer_hand.cards << deck.hit until sum(dealer_hand.cards) >= 17
  end

  def determine_results(dealer_hand, player_hand)
    if sum(player_hand.cards) > 21
      return "Player bust!"
    elsif sum(dealer_hand.cards) > 21
      return "Dealer bust!"
    elsif sum(player_hand.cards) > sum(dealer_hand.cards)
      return "Player wins!"
    elsif sum(dealer_hand.cards) > sum(player_hand.cards)
      return "Dealer wins!"
    elsif sum(dealer_hand.cards) == sum(player_hand.cards)
      return "Tie!"
    end
  end

  def sum(hand)
    values = hand.map { |card| card.value }
    sum = 0
    values.each do |value|
      if value == "A"
        sum += 1
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end
    values.each do |value|
      sum += 10 if elevent_point_ace?(value, sum)
    end
    sum
  end

  def elevent_point_ace?(value, sum)
    value == "A" && sum < 12
  end

end