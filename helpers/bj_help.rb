module BJ

  def new_hand(player)
    hand = session["deck"].sample(2)
    session["deck"].delete_if {|card| hand.include?(card)}
    session[player+"hand"] = hand
    hand
  end

  def new_deck
    suit = ["Clb", "Dmd", "Hrt", "Spd"]
    number = (1..10).to_a + ["J", "Q", "K"]
    array = number.product(suit)
    session["deck"] = array
    return array
  end

  def hit
    card = session["deck"].sample(1)
    session["deck"].delete(card)
    session["playerhand"] << card

  end

  def hand_sum(player)
    sum = 0
    session[player+"hand"].each |card| do
    card[0].is_a?(Integer) ? sum += card[0] : sum += 10
    end
    sum
end
