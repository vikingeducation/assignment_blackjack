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


  def busted?(hand)
    total_hand(hand) > 21
  end


  def blackjack_in_hand?(hand)
    total_hand(hand) == 21
  end


  def winner?(player_hand, dealer_hand)
    hands = { :Player => total_hand(player_hand), 
              :Dealer => total_hand(dealer_hand) }

    hands.keep_if do |key,val| 
      val <= 21
    end
    
    hands.max_by { |key,val| val }
  end


  def draw?(player_hand, dealer_hand)
    total_hand(player_hand) == total_hand(dealer_hand)
  end


end