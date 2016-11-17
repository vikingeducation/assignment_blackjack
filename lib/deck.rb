class Card
  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end
end

class Deck < Card
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
end
