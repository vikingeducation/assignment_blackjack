module Blackjack
  DECK = (0..51).to_a
  
  def deal(dealt_cards, target_hand)
    cards = DECK - dealt_cards
    cards = cards.shuffle
    target_hand.push(cards.sample)
    target_hand
  end 

  def bust (hand)
    hand.reduce(0){|acc, val| acc += (val % 13 + 1)} > 21
  end
  
  def dealer_hand
    until total_hand < 17
      hit(total_hand)
    end

  end
end