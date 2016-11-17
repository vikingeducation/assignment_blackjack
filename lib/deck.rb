class Card

  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def to_s
    "#{rank} of #{suit}"
  end

end

class Deck

  attr_accessor :cards

  def initialize
    @cards = []
    suits = ["spades", "hearts", "clubs", "diamonds"]
    ranks = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
    suits.each do |suit|
      ranks.each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
  end

  def deal_card
    @cards.pop
  end

  def show_deck
    p @cards
  end

  def shuffle!
    @cards.shuffle!
  end
end

class Hand

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def sort

  end

  def value
    total = 0
    cards.sort! do |a, b|
      if a.rank == "Ace"
        1
      elsif b.rank == "Ace"
        -1
      else a.rank <=> b.rank
      end
    end
    cards
    cards.each do |card|
      rank = card.rank
      if numeric_string?(rank)
        total += rank.to_i
      else
        total += case rank
                  when "Jack" then 10
                  when "Queen" then 10
                  when "King" then 10
                  when "Ace" then total <= 10 ? 11 : 1
                end
      end
    end
    total
  end

  def numeric_string?(string)
    string == string.to_i.to_s
  end

end
