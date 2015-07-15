module Blackjack
  DECK = (0..51).to_a

  def deal(dealt_cards, target_hand)
    cards = (DECK - dealt_cards).shuffle
    target_hand.push(cards.sample)
  end

  def initial_hands
    hand1, hand2 = [], []
    deal_initial_cards(hand1, hand2)
    return hand1, hand2
  end

  def deal_initial_cards(hand1, hand2)
    deal([], hand1)
    deal(hand1, hand2)
    deal(hand1 + hand2, hand1)
    deal(hand1 + hand2, hand2)
  end

  #strictly for showing the hand to player
  def card_to_hand(card)
    faces = {1 => "Ace", 11 => "Jack", 12 => "Queen", 13 => "King"}
    suits = {0 => "spades", 1 => "clubs", 2 => "hearts", 3 => "diamonds"}
    ret = ""
    faces[(card % 13) + 1].nil? ? value = (card % 13) + 1 : value = faces[(card % 13) + 1]
    ret += value.to_s + " of " + suits[(card / 13)]
  end

  def bust? (hand)
    value_hand(hand) > 21
  end

  def blackjack?(hand)
    value_hand(hand) == 21
  end

  def value_hand(hand)
    aces, other = hand.partition{|val| val % 13 == 0}
    digit, face = other.partition{|val| val % 13 < 9}

    sum = digit.reduce(0){|acc, val| acc += (val % 13 + 1)}

    sum += 10 * face.length

    aces.length.times do
      (sum + 11 > 21) ? sum += 1 : sum += 11
    end
    sum
  end

  def dealer_plays(dealt_cards, hand)
    until value_hand(hand) >= 17
      deal(dealt_cards, hand)
    end
  end
end