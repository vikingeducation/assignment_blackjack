

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
      sum += values[card[0]]
    end
    until sum < 21
      card_count = 0
      while card_count < hand.length
        if hand[card_count][0] == "A"
          sum -= 10
        end
        card_count += 1
      end
    end
    sum
  end




end