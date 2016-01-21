class Blackjack

  attr_accessor :player_hand, :dealer_hand

  def initialize(player_hand = Hand.new,dealer_hand = Hand.new)
    @player_hand = player_hand
    @dealer_hand = dealer_hand
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

  VALUES = {
    'Ace' => 11,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'Jack' => 10,
    'Queen' => 10,
    'King' => 10
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

  def dealers_turn
    while @dealer_hand.hard_value < 17
      deal(@dealer_hand)
    end
  end

end

class Hand
  attr_accessor :cards

  def self.deserialize(str)
    hand = new
    str.chars.each_slice(2) do |card|
      suit = Blackjack::SUITS.invert[card[1]]
      rank = Blackjack::RANKS.invert[card[0]]
      hand.cards << Card.new(rank: rank,suit: suit)
    end
    hand
  end

  def initialize(cards = [])
    @cards = cards
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

  def hard_value
    total = @cards.inject(0) { |sum, card| sum += card.value }

    aces.each do |ace|
      total -= 10
    end

    total
  end

  def serialize
    @cards.map(&:to_s).join
  end

end

class Card
  attr_accessor :rank, :suit

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

  def value
    Blackjack::VALUES[@rank]
  end
end
