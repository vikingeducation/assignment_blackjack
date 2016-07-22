# ./helpers/checkers_helper.rb

module BlackjackHelper

  def save_deck(board)
  end

  def load_deck

    Deck.new(session["deck_arr"])
  end

  def save_deck(deck_arr)
    session["deck_arr"] = deck_arr
  end

  def load_player_hand
    Player.new(session["player_hand_arr"]).hand
  end

  def save_player_hand(player_hand)
    session["player_hand_arr"] = player_hand
  end

  def load_dealer_hand
  end

  def save_dealer_hand

  end



end

