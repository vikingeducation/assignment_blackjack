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

  def sum(hand)
    sum_if_11(hand) <= 21 ? sum_if_11(hand) : sum_if_1(hand)
  end

  def sum_if_11(hand)
    values = hand.map { |card| card.value }
    sum = 0
    values.each do |value|
      if value == "A"
        sum += 11
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end
    sum
  end

  def sum_if_1(hand)
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
    sum
  end

end