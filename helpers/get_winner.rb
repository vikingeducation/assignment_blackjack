module GetWinner

  def winner(dealer_hand, player_hand)
    dealer_score = prox_twenty_one(dealer_hand)
    player_score = prox_twenty_one(player_hand)

    return "TIE!!!" if player_score < 1 && dealer_score < 1
    return "TIE!!!" if player_score == dealer_score

    return "Dealer busts Player wins" if dealer_score < 0
    return "You bust, I win" if player_score < 0

    if player_score < dealer_score
      "You Win!!! Congratulations!"
    else
      "I Win!! Your money is mine!!"
    end
  end

  def prox_twenty_one(hand_score)
    if hand_score > 21
      -1
    else
      21 - hand_score
    end
  end

end
