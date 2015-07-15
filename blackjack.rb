module Blackjack
  DECK = (0..51).to_a

  def deal(dealt_cards, target_hand)
    cards = DECK - dealt_cards
    cards = cards.shuffle
    target_hand.push(cards.sample)
    target_hand
  end
  
  def initial_hands
    hand1 = []
    hand2 = []
    deal([], hand1)
    deal(hand1, hand2)
    deal(hand1 + hand2, hand1)
    deal(hand1 + hand2, hand2)

    return hand1, hand2
  end
  

  #strictly for showing the hand to player
  def card_to_hand(card)
    faces = {1 => "Ace", 11 => "Jack", 12 => "Queen", 13 => "King"}
    suits = {0 => "spades", 1 => "clubs", 2 => "hearts", 3 => "diamonds"}
    ret = ""
    if faces[(card % 13) + 1]
      value = faces[(card % 13) + 1]
    else
      value = (card % 13) + 1
    end
    ret += value.to_s
    ret += " of "
    ret += suits[(card / 13)]
  end

  def bust (hand)
    hand.reduce(0){|acc, val| acc += (val % 13 + 1)} > 21
  end
  
  def value_hand(hand)
    aces, other = hand.partition{|val| val % 13 == 0}
    sum = other.reduce(0){|acc, val| acc += (val % 13 + 1)}
    until aces.empty?
      current = aces.pop
      if sum + 11 > 21
        sum += 1
      else
        sum += 11
      end
    end
    sum
  end

  def dealer_hand
    until total_hand < 17
      hit(total_hand)
    end

  end
end