module HandCalculator


  def total_hand(hand)
    aces_in_hand?(hand) ? total_hand_with_aces(hand) : total_hand_without_aces(hand)
  end


  def aces_in_hand?(hand)
    hand.any? { |card| card[0] == "A" }
  end


  def total_hand_without_aces(hand)
    values = []

    hand.each do |card|
      next if card[0] == "A"
      if ["K", "Q", "J"].include?(card[0])
        values << 10
      else
        values << card[0]
      end
    end
    
    values.reduce(:+)
  end


  def total_hand_with_aces(hand)
    aces = Array.new(hand.select { |card| card[0] == "A" })
    value = total_hand_without_aces(hand)
    num_of_aces = aces.length
    if value + 11 + (num_of_aces - 1) > 21
      value + num_of_aces
    else
      value + 11 + (num_of_aces - 1)
    end
  end


  def hand_busted?(hand)
    total_hand(hand) > 21
  end


  def blackjack_in_hand?(hand)
    total_hand(hand) == 21
  end


  def winner?(player_hand_value, dealer_hand_value)
    unless draw?(player_hand_value, dealer_hand_value)
      determine_best_hand(player_hand_value, dealer_hand_value)
    end
  end


  def determine_best_hand(player_hand_value, dealer_hand_value)
    hands = { :Player => player_hand_value, 
              :Dealer => dealer_hand_value }

    hands.keep_if do |key,val| 
      val <= 21
    end
    
    return hands.max_by { |key,val| val }[0]
  end


  def draw?(player_hand_value, dealer_hand_value)
    player_hand_value == dealer_hand_value
  end


end