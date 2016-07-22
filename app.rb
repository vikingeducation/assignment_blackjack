require 'sinatra'

class Deck
  attr_reader :card

  SUITS = ["C", "H", "S", "D"]
  RANK = ["A", "K", "Q", "J"].concat((2..10).to_a)

  Card = Struct.new(:rank, :value, :suit)

  def initialize
  end

  def get_deck
    cards = []
    SUITS.each do |suit|
      RANK.each do |card|
        cards << Card.new(card, 0, suit)
      end
    end
    cards
  end
end



get "/blackjack" do 


  erb :blackjack

end