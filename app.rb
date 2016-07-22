require 'sinatra'
enable :sessions

class Deck
  attr_reader :deck, :player_hand, :dealer_hand, :player_win, :dealer_win, :pvalue, :dvalue

  SUITS = ["Clubs", "Heards", "Spades", "Diamonds"]
  RANK = ["A", "K", "Q", "J"].concat((2..10).to_a)

  Card = Struct.new(:rank, :value, :suit)

  def initialize(cards=nil, player_hand = [], dealer_hand = [])
    if cards
      @deck = cards.shuffle
      @player_hand = player_hand
      @dealer_hand = dealer_hand
    else
      @player_hand = []
      @dealer_hand = []
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
    get_card(@player_hand)
    get_card(@dealer_hand)
    get_card(@player_hand)
    get_card(@dealer_hand)
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


  def show_rank_suit(hand)
    hand.map do |card|
      [card.rank, card.suit]
    end
  end

end




get "/blackjack" do 

  deck = Deck.new(session['cards'])
  deck.deal
  player_hand = deck.show_rank_suit(deck.player_hand)
  dealer_hand = deck.show_rank_suit(deck.dealer_hand)




  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand }

end