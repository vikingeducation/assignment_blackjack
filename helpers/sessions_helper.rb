module SessionsHelper
  # Bank

  def load_bank
    Bank.new(session["bank"]).bank
  end

  def save_bank(bank)
    session["bank"] = bank
  end
  # Deck
  def load_deck
    Deck.new(session["deck_arr"]).deck_arr
  end

  def save_deck(deck_arr)
    session["deck_arr"] = deck_arr
  end

  # Player Hand
  def load_player_hand
    Hand.new(session["player_hand_arr"]).hand_arr
  end

  def save_player_hand(player_hand)
    session["player_hand_arr"] = player_hand
  end

  # Dealer Hand
  def load_dealer_hand
    Hand.new(session["dealer_hand_arr"]).hand_arr
  end

  def save_dealer_hand(dealer_hand)
    session["dealer_hand_arr"] = dealer_hand
  end

  # Player Score
  def load_player_score
   Hand.new(session["player_hand_arr"]).score
  end

  def save_player_score(player_score)
    session["player_score"] = player_score
  end

  # Dealer Score
  def load_dealer_score
   Hand.new(session["dealer_hand_arr"]).score
  end

  def save_dealer_score(dealer_score)
    session["dealer_score"] = dealer_score
  end

end