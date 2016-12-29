module BlackjackHelper

  def load_player_hand
    session[:player_hand]
  end

  def load_dealer_hand
    session[:dealer_hand]
  end

  def load_deck
    session[:deck]
  end

  def save_sessions(deck, player, dealer)
    session[:deck] = deck
    session[:player_hand] = player
    session[:dealer_hand] = dealer
  end
   
  def player_hits(player_hand, deck)
    player_hand.cards << deck.hit
  end

  def dealer_hits(dealer_hand, deck)
    dealer_hand.cards << deck.hit until dealer_hand.sum >= 17
  end

  def determine_results(dealer_sum, player_sum)
    if player_sum > 21
      return "Player bust!"
    elsif dealer_sum > 21
      return "Dealer bust!"
    elsif player_sum > dealer_sum
      return "Player wins!"
    elsif dealer_sum > player_sum
      return "Dealer wins!"
    elsif dealer_sum == player_sum
      return "Tie!"
    end
  end

end