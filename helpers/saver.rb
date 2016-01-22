module Saver

  def save_dealer(dealer)
    session[:dealer] = dealer
  end


  def save_player(player)
    session[:player] = player
  end


  def save_deck(deck)
    session[:deck] = deck
  end


  def save_bankroll(bankroll)
    session[:bankroll] = bankroll
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