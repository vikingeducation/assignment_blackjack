require_relative 'dealer'

class Player

  attr_reader :hand

  def initialize
    @hand = []
  end

  def draw(cards)
    @hand << cards.pop
  end

  def hit_or_stay?
    
  end

end