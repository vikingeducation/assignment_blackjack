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

class Deck < Card

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

class Hand < Deck

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
    p cards
    cards.each do |card|
      rank = card.rank
      total += case rank
                when "2" then 2
                when "3" then 3
                when "4" then 4
                when "5" then 5
                when "6" then 6
                when "7" then 7
                when "8" then 8
                when "9" then 9
                when "10" then 10
                when "Jack" then 10
                when "Queen" then 10
                when "King" then 10
                when "Ace" then total <= 10 ? 11 : 1
              end
    end
    total
  end

end
