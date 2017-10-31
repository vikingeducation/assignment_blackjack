module BlackjackHelper

  BLACKJACK = 21

  def display_card(card)
    "#{card[0]} of #{card[1]}"
  end

  def game_ending_hand?(hand)
    busted?(hand) || blackjack?(hand)
  end

  def busted?(hand)
    hand > BLACKJACK
  end

  def blackjack?(hand)
    hand == BLACKJACK
  end

  def determine_winner(dealer, player)
    if dealer == player
      'Dealer. You forfeited.'
    elsif busted?(player) || (dealer > player && dealer <= BLACKJACK)
      'Dealer'
    elsif busted?(dealer) || (player > dealer && player <= BLACKJACK)
      'You'
    else
      'No winner'
    end
  end

  def display_winner(winner)
    "The winner is: #{winner}"
  end

end