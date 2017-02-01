class Deck
  attr_accessor :cards
  def initialize(cards=nil)
    @cards = cards ? JSON.parse(cards) : make_deck
  end

  def make_deck
    %w{1 2 3 4 5 6 7 8 9 10 jack queen king ace}.product(%w{diamonds clubs hearts spades}).shuffle
  end

  def deal(one, two)
    2.times do
      s = @cards.sample
      one.hand << s
      @cards.delete(s)
      s = @cards.sample
      two.hand << s
      @cards.delete(s)
    end
  end

  def hit(player)
    s = @cards.sample
    player.hand << s
    @cards.delete(s)
  end
end
