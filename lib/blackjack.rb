class Blackjack
  SUITS = {
    'Spades' => "S",
    'Diamonds' => "D",
    'Clubs' => "C",
    'Hearts' => 'H'
  }

  RANKS = {
    'Ace' => "A",
    '2' => "2",
    '3' => "3",
    '4' => "4",
    '5' => "5",
    '6' => "6",
    '7' => "7",
    '8' => "8",
    '9' => "9",
    '10' => "T",
    'Jack' => "J",
    'Queen' => "Q",
    'King' => "K"
  }

end

class Deck

end

class Card
  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{Blackjack::RANKS[@rank]}#{Blackjack::SUITS[@suit]}"
  end
end

p Card.new(rank: "Ace", suit: "Spades").to_s

