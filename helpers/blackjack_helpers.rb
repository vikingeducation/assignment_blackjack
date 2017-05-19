module BlackjackHelpers
  def save_dealer
  end

  def load_dealer
  end

  def save_player
  end

  def load_player
  end

  def save_deck
  end

  def load_deck
  end

  # helper method to reset game
  def reset_game
    session[:dealer_hand] = nil
    session[:deck_cards] = nil
    session[:player_hand] = nil
  end
end
