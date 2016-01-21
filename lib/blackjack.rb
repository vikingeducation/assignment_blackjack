class Blackjack

  attr_accessor :player_hand, :dealer_hand, :player_bankroll, :player_bet

  def initialize(player_hand = Hand.new,dealer_hand = Hand.new, player_bankroll=0, player_bet=0)
    @player_hand = player_hand
    @player_bankroll = player_bankroll
    @player_bet = player_bet
    @dealer_hand = dealer_hand
  end

  SUITS = {
    'Spades' => "S",
    'Diamonds' => "D",
    'Clubs' => "C",
    'Hearts' => 'H'
  }

  RANKS = {
    'A' => "A",
    '2' => "2",
    '3' => "3",
    '4' => "4",
    '5' => "5",
    '6' => "6",
    '7' => "7",
    '8' => "8",
    '9' => "9",
    '10' => "T",
    'J' => "J",
    'Q' => "Q",
    'K' => "K"
  }

  VALUES = {
    'A' => 11,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10
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

  def winner
    player_value = @player_hand.best_value
    dealer_value = @dealer_hand.best_value
    if player_value > 21
      :dealer
    elsif dealer_value > 21
      :player
    elsif  dealer_value > player_value
      :dealer
    elsif  dealer_value < player_value
      :player
    else
      :draw
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
