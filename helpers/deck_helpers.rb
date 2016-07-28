module DeckHelper

  def create_deck
    suits = ['H', 'D', 'S', 'C']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    session[:deck] = suits.product(values).shuffle!
    session[:dealer_cards] = []
    session[:player_cards] = []
    2.times { deal_dealer ; deal_player }
  end

  def dealer_hand
    session[:dealer_cards]
  end

  def player_hand
    session[:player_cards]
  end

  def deal_dealer
    session[:dealer_cards] << session[:deck].pop
  end

  def deal_player
    session[:player_cards] << session[:deck].pop
  end

end