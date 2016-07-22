class Hand

  initialize(deck)

    @deck    #dealer and and players hand
    @both_players_hands = [@players_hand, @dealers_hand]
  end

  def player_hit(player_hand, deck)
    player_hand << @deck.pop 
  end

  def dealer_hit(dealer_hand, deck)
    dealer_hand << @deck.pop
  end

end