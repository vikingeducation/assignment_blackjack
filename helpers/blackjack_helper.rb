module BlackjackHelper

  def load_player_hand
    session[:player_cards]
  end

  def load_bankroll
    session[:bankroll]
  end

  def load_bet
    session[:bet]
  end

  def load_dealer_hand
    session[:dealer_hand]
  end

  def load_deck
    session[:deck]
  end

  def save_sessions(vars={})
    session[:deck] = vars[:deck] if vars[:deck]
    session[:player_cards] = vars[:player_cards] if vars[:player_cards]
    session[:bankroll] = vars[:bankroll] if vars[:bankroll]
    session[:bet] = vars[:bet] if vars[:bet]
    session[:dealer_cards] = vars[:dealer_cards] if vars[:dealer_cards]
  end
   
  def player_hits(player_hand, deck)
    player_hand.cards << deck.hit
  end

  def dealer_hits(dealer_hand, deck)
    dealer_hand.cards << deck.hit until dealer_hand.sum >= 17
  end

  def determine_results(dealer_hand, player_hand)
    if player_hand.sum > 21
      return "Player bust!"
    elsif dealer_hand.sum > 21
      return "Dealer bust!"
    elsif player_hand.sum > dealer_hand.sum
      player_hand.wins
      return "Player wins!"
    elsif dealer_hand.sum > player_hand.sum
      return "Dealer wins!"
    elsif dealer_hand.sum == player_hand.sum
      player_hand.ties
      return "Tie!"
    end
  end

end