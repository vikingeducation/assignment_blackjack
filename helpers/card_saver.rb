module CardSaver

  def save_hands(dealer, player, deck)
    session[:dealer] = dealer
    session[:player] = player
    session[:deck] = deck
  end

  def load_dealer
    session[:dealer]
  end

  def load_player
    session[:player]
  end

  def load_deck
    session[:deck]
  end
end