module GetWinner

  def winner(dealer_hand, player_hand)
    return :tie if player_hand.bust? && dealer_hand.bust?
    return :tie if player_hand.value == dealer_hand.value

    return :player if dealer_hand.bust?
    return :dealer if player_hand.bust?

    return :player if player_hand.value > dealer_hand.value
    return :dealer
  end

  def get_winning_message(winning_player, dealer_hand, player_hand)
    if winning_player == :player && dealer_hand.bust?
      "Dealer busted! You win!"
    elsif winning_player == :player
      "You win!"
    elsif winning_player == :tie && player_hand.bust? && dealer_hand.bust?
      "Both players busted! Tie!"
    elsif winning_player == :tie
      "Tie!"
    elsif winning_player == :dealer && player_hand.bust?
      "You busted! I win!"
    elsif winning_player == :dealer
      "I win! I take your money!"
    end
  end

end
