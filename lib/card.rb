class Card
  attr_accessor :rank, :suit

  UNICODE = {
    "Spades" => "\u2660",
    "Diamonds" => "\u2666",
    "Hearts" => "\u2665",
    "Clubs" => "\u2663",
  }

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{Blackjack::RANKS[@rank]}#{Blackjack::SUITS[@suit]}"
  end

  def ace?
    @rank == "A"
  end

  def unicode_suit
    UNICODE[@suit]
  end

  def color
    case @suit
    when "Diamonds"
      "red"
    when "Hearts"
      "red"
    when "Clubs"
      "black"
    when "Spades"
      "black"
    end
  end

  def value
    Blackjack::VALUES[@rank]
  end
end
