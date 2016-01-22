class Hand
  attr_accessor :cards, :name

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
