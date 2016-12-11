module BlackjackHelper
  def load_deck
    session[:deck] = [].to_json if session[:deck].nil?
  end

  def load_player
    session[:player] = [].to_json if session[:player].nil?
  end

  def load_dealer
    session[:dealer] = [].to_json if session[:dealer].nil?
  end

  def save_deck(card_deck)
    session[:deck] = card_deck.deck.to_json
  end

  def save_player(player_hand)
    session[:player] = player_hand.hand.to_json
  end

  def save_dealer(dealer_hand)
    session[:dealer] = dealer_hand.hand.to_json
  end

  def check_win?(person_1,person_2)
    return true if person_1.hi > person_2.hi & !person_1.bust? & person_1 <= 21
  end
end