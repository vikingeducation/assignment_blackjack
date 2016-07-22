class Blackjack

=begin

blackjack is main game, creates the deck
and sends cards to individual games

hand hold hit methods

game resolves hand then moves to blackjack

=end


attr_accessor :cards

  def initialize(deck=nil)
    if deck
      @cards = deck
    else
      @cards = []
      create_deck
    end
  end

  def create_deck
    4.times do
      (1..13).each do |n|
      @cards << n
      end
    end
    @cards.shuffle!
    @cards
  end


  def card_to(player)
    player_hand << @cards.pop
  end


  def deal_to_players(num_players)
    cards_in_play = []
    num_players.times do
      cards_in_play << deal_hand(@cards)
    end
    cards_in_play
  end

  private 

  def deal_hand(deck)
    #deal 2 random cards
    hand = []
    2.times do
      hand << deck.pop
    end
    hand
  end
end