module BlackjackHelpers
  def save_dealer(dealer_hand)
    session[:dealer_hand] = dealer_hand
  end

  def load_dealer
    Dealer.new(session[:dealer_hand])
  end

  def save_player(player_hand)
    session[:player_hand] = player_hand
  end

  def load_player
    Player.new(session[:player_hand])
  end

  def save_cards(cards)
    session[:cards] = cards
  end

  def load_cards
    Blackjack.new(session[:cards])
  end

  # helper method to reset game
  def reset_game
    session[:dealer_hand] = nil
    session[:player_hand] = nil
    session[:cards] = nil
  end
end
