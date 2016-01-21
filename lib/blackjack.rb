class Blackjack

  attr_accessor :player_hand, :dealer_hand

  def initialize(player_hand,dealer_hand)
    @player_hand = player_hand || Hand.new
    @dealer_hand = dealer_hand || Hand.new
  end

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

  def random_card
    Card.new(rank: RANKS.keys.sample, suit: SUITS.keys.sample)
  end

  def first_deal
    2.times do
      deal(@player_hand)
      deal(@dealer_hand)
    end
  end

  def deal(player)
    player.cards << random_card
  end

end

class Hand
  attr_accessor :cards

  def self.deserialize(str)
    hand = new
    str.chars.each_slice(2) do |card|
      suit = Blackjack::SUITS.invert[card[1]]
      rank = Blackjack::RANKS.invert[card[0]]
      hand.cards << Card.new(rank,suit)
    end
    hand
  end

  def initialize(cards)
    @cards = []
  end

  def aces
    @cards.select(&:ace?)
  end

  def best_value
    total = @cards.inject(0) { |sum, card| sum += card.value }

    aces.each do |ace|
      break if total <= 21
      total -= 10
    end

    total
  end

end

class Card
  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{Blackjack::RANKS[@rank]}#{Blackjack::SUITS[@suit]}"
  end

  def ace?
    @rank == "Ace"
  end
end

p Card.new(rank: "Ace", suit: "Spades").to_s
