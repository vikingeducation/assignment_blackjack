module ControllerHelpers

  def check_hands(deck, player_hand, dealer_hand)
    if session["player_hand"] && session["dealer_hand"]
      player_hand = session["player_hand"]
      dealer_hand = session["dealer_hand"]
    else
      player_hand = deck.show_rank_suit(deck.get_player_points)
      dealer_hand = deck.show_rank_suit(deck.get_dealer_points)
    end
    [player_hand, dealer_hand]
  end


  def to_array(deck)
    deck.deck.map { |card| [card.rank,card.suit] }
  end

  def card_array_to_structs(hand)
    hand.map do |card|
      Card.new(card[0], card[1], card[2])
    end
  end

  def store_player_hand(deck, hand)
    deck.player_hand = card_array_to_structs(hand)
  end

  def store_dealer_hand(deck, hand)
    deck.dealer_hand = card_array_to_structs(hand)
  end

  def store_session(player_hand,dealer_hand,deck)
    session['player_hand'] = player_hand
    session['dealer_hand'] = dealer_hand
    session['cards'] = to_array(deck)
  end

end