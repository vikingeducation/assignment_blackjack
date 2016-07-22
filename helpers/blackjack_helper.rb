# ./helpers/checkers_helper.rb

module BlackjackHelper

  def new_game?
    !!(session["deck_arr"])
  end
#returns deck_arr (arr) from session
  def load_deck
    Deck.new(session["deck_arr"]).deck_arr
  end

#takes deck_arr and saves it to session hash
  def save_deck(deck_arr)
    session["deck_arr"] = deck_arr
  end

#returns player_hand (arr) from session
  def load_hand
    Hand.new(session["player_hand_arr"]).hand_arr
  end

#takes player_hand and saves it to session hash
  def save_hand(player_hand)
    session["player_hand_arr"] = player_hand
  end

  def load_dealer_hand
    DealerHand.new(session["dealer_hand_arr"]).hand_arr
  end

  def save_dealer_hand(dealer_hand)
    session["dealer_hand_arr"] = dealer_hand
  end


end

