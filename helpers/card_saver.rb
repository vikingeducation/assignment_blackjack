module CardSaver

  def save_hands(dealer, player)
    session[:dealer] = dealer
    session[:player] = player
  end

  def load_dealer
    session[:dealer]
  end

  def load_player
    session[:player]
  end
end