class Blackjack

CARDS = [1,2,3,4,5,6,7,8,9,10,11,12,13]
SUITS = ["c","d","h","s"]

attr_accessor :cards

  def initialize(deck=nil)
    if deck
      @cards = deck
    else
      @cards = []
      create_deck
    end
  end

  #cards is an array of arrays ie [5, "c"]
  def create_deck
    @cards = CARDS.product(SUITS).shuffle
    # 4.times do
    #   (1..13).each do |n|
    #   @cards << n
    #   end
    # end
    # @cards.shuffle!
    # @cards
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