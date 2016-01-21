require './deck.rb'
class Blackjack

  attr_reader :dealers_hand, :players_hand

  def initialize(deck)
    @deck = Deck.new if deck.nil?
  end

  def start_game
    @dealers_hand = []
    @players_hand = []
    2.times do
      @layers_hand << @deck.deal_card
      @dealers_hand << @deck.deal_card
    end
    @dealers_hand, @players_hand
  end

  def hit
    @players_hand << @deck.deal_card
  end

  def split
    first_pair = []
    second_pair = []
    if @players_hand.size == 2
      first_pair << @players_hand[0]
      first_pair << @deck.deal_card
      second_pair << @players_hand[1]
      second_pair << @deck.deal_card
      @players_hand = [first_pair, second_pair]
    end

  end
end