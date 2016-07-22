require 'sinatra'

class Deck
  attr_reader :deck, :player_hand, :dealer_hand, :player_win, :dealer_win, :pvalue, :dvalue

  SUITS = ["C", "H", "S", "D"]
  RANK = ["A", "K", "Q", "J"].concat((2..10).to_a)

  Card = Struct.new(:rank, :value, :suit)

  def initialize(cards=nil)
    if cards
      @deck = cards.shuffle
    else
      @deck = get_deck.shuffle
      deal
    end
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

  def get_card(hand)
    hand.push @deck.pop
  end

  def deal
    @player_hand = [get_card,get_card]
    @dealer_hand = [get_card,get_card]
    @player_win = blackjack?(@player_hand)
    @dealer_win = blackjack?(@dealer_hand)
    any_win?
    compute_value
  end

  def player_hit
    get_card(@player_hand)
  end

  def dealer_hit
    get_card(@dealer_hand)
  end

  def fold
  end

  def blackjack?(hand)
    return true if hand[0].rank == 'a' && hand[1].value == 10
    return true if hand[1].rank == 'a' && hand[0].value == 10
  end

  def any_win?
    @player_win || @dealer_win
  end

  def compute_value
    @pvalue = @player_hand.reduce(0) do |m,n|
      m + n.value
    end
    @dvalue = @dealer_hand.reduce(0) do |m,n|
      m + n.value
    end
  end

end



get "/blackjack" do 

  cards = session['cards']
  deck = Deck.new(cards)

  erb :blackjack, locals: { deck: deck }

end