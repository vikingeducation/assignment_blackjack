

module GameHelpers



  def check_hand(hand)
    values = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 10,
    "Q" => 10,
    "K" => 10,
    "A" => 11
  }

    sum = 0
    hand.each do |card|
      if card.length  == 3
        sum += 10
      else
        sum += values[card[0]]
      end
    end
    if sum > 21
      card_count = 0
      while sum > 21 && card_count < hand.length
        if hand[card_count][0] == "A"
          sum -= 10
        end
        card_count += 1
      end
    end
    sum
  end

  def compare_values(player_hand, dealer_hand)
    return "Dealer busts!, you win" if check_hand(dealer_hand) > 21  
    check_hand(player_hand) > check_hand(dealer_hand) ? "You win!" : "You lose, sorry"
  end




end
