require 'pry'
require './helpers/view_helpers'
require './helpers/controller_helpers'
require 'sinatra'
require 'sinatra/form_helpers'


helpers ViewHelpers
helpers ControllerHelpers

enable :sessions

Card = Struct.new(:rank, :value, :suit)

class Deck
  attr_reader :deck, 
              :player_win, 
              :dealer_win, 
              :pvalue, 
              :dvalue
  attr_accessor :player_hand, 
                :dealer_hand

  SUITS = ["Clubs", "Hearts", "Spades", "Diamonds"]
  RANK = ["A", "K", "Q", "J"].concat((2..10).to_a)

  def initialize(cards=nil, player_hand = [], dealer_hand = [])
    if cards
      #convert array to deck object
      @deck = cards.map{ |card| Card.new(card[0],0,card[1]) }.shuffle
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
    @pblackjack = blackjack?(@player_hand)
    @dblackjack = blackjack?(@dealer_hand)
    any_win?
    compute_value
  end

  def player_hit
    get_card(@player_hand)
  end

  def dealer_hit
    get_card(@dealer_hand)
  end

  #Check if player's hand beats dealer's.
  def compare_hands
    total_player = get_total_points(get_player_points)
    total_dealer = get_total_points(get_dealer_points)
    #NOTE: Check for dealer bust?
    total_player > total_dealer
  end

  def dealer_should_hit?
    total_dealer = get_total_points(get_dealer_points)
    total_dealer < 17
  end

  def bust_player
    get_total_points(get_player_points) > 21 ? "Player busts. Dealer wins."  : nil
  end

  def tie?
    return :tie if @pblackjack && @dblackjack
  end

  #When the player busts or stays
  def end_game
    dealer_hit while dealer_should_hit?
    compare_hands ? "Player wins." : "Dealer wins."
  end

  #Getting points.
  def get_total_points(hand)
    hand.reduce(0) do |m,card|
      m + card.value
    end
  end

  def get_dealer_points
    @dealer_hand.map do |card|
      card.value = get_card_points(card)
      card
    end
  end

  def get_player_points
    @player_hand.map do |card|
      card.value = get_card_points(card)
      card
    end
  end

  def get_card_points(card)
    case card.rank
    when 'A', 'K', 'Q', 'J'
      10
    when Fixnum
      card.rank
    end
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
      [card.rank, card.value, card.suit]
    end
  end

end

get "/blackjack" do 

  deck = Deck.new(session['cards'])
  player_hand = nil; dealer_hand = nil
  #Check if hands are already present in the session.
  hands = check_hands(deck, player_hand,dealer_hand)
  deck.compute_value
  outcome = deck.bust_player
  session['cards'] = to_array(deck)
  session['player_hand'] = hands[0]
  session['dealer_hand'] = hands[1]

  erb :blackjack, locals: { deck: deck, player_hand: hands[0], dealer_hand: hands[1], outcome: outcome }

end

post "/blackjack/hit" do

  deck = Deck.new(session['cards'])
  store_player_hand(deck, session["player_hand"])
  store_dealer_hand(deck, session["dealer_hand"])
  deck.player_hit
  player_hand = deck.show_rank_suit(deck.get_player_points)
  dealer_hand = deck.show_rank_suit(deck.get_dealer_points)
  outcome = deck.bust_player || deck.tie?
  if outcome
    session.clear
  else
    store_session(player_hand,dealer_hand,deck)
  end

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand, outcome: outcome }

end


get "/blackjack/stay" do
  deck = Deck.new(session['cards'])
  store_player_hand(deck, session["player_hand"])
  store_dealer_hand(deck, session["dealer_hand"])
  outcome = deck.tie? ? :tie : deck.end_game
  session.clear
  player_hand = deck.show_rank_suit(deck.player_hand)
  dealer_hand = deck.show_rank_suit(deck.dealer_hand)

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand, outcome: outcome }
end