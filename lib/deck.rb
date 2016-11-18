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
