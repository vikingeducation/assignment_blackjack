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
end