module BlackjackHelper

  def display_card(card)
    "#{card[0]} of #{card[1]}"
  end

  def build_deck
    suits = %w(Hearts Diamonds Clubs Spades)
    numbers = (2..10).to_a.unshift('A').push(%w(J Q K)).flatten
    numbers.product(suits).shuffle
  end

end