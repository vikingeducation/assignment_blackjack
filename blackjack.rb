module Blackjack
  DECK = (0..51).to_a
  FACES = {1 => "Ace", 11 => "Jack", 12 => "Queen", 13 => "King"}
  SUITS = {0 => "spades", 1 => "clubs", 2 => "hearts", 3 => "diamonds"}

  # Deal the target hand a card from the remaining cards
  # in the deck.
  # Dealt cards should be any player and dealer hands.
  def deal(dealt_cards, target_hand)
    next_card = remaining_cards(dealt_cards).sample
    target_hand.push(next_card)
  end

  def remaining_cards(dealt_cards)
    remaining = (DECK - dealt_cards)
    if session['split_hands']
      session['split_hands'].each do |hand|
        remaining -= hand
      end
    end
    remaining
  end

  # Returns two hands with two cards each.
  def initial_hands
    hand1, hand2 = [], []
    deal_initial_cards(hand1, hand2)
    return hand1, hand2
  end

  # Deal two cards each to two hands alternatingly.
  def deal_initial_cards(hand1, hand2)
    deal([], hand1)
    deal(hand1, hand2)
    deal(hand1 + hand2, hand1)
    deal(hand1 + hand2, hand2)
  end

  #strictly for showing the hand to player
  def card_to_hand(card)
    ret = ""
    FACES[(card % 13) + 1].nil? ? value = (card % 13) + 1 : value = FACES[(card % 13) + 1]
    ret += value.to_s + " of " + SUITS[(card / 13)]
  end

  def bust? (hand)
    value_hand(hand) > 21
  end

  def blackjack?(hand)
    value_hand(hand) == 21
  end

  # Split a hand into ace, face, and other cards.
  # Total up the other and face card values.
  # Then, add the maximum score of aces unless it would bust
  # the hand, then add minimum values for remaining aces.
  def value_hand(hand)
    aces, other = hand.partition{|val| val % 13 == 0}
    digit, face = other.partition{|val| val % 13 < 9}

    sum = digit.reduce(0){|acc, val| acc += (val % 13 + 1)}
    sum += 10 * face.length
    aces.length.times {(sum + 11 > 21) ? sum += 1 : sum += 11}

    sum
  end

  # The dealer hits until they have 17 or more card value.
  def dealer_plays(dealt_cards, hand)
    until value_hand(hand) >= 17
      deal(dealt_cards, hand)
    end
  end
end