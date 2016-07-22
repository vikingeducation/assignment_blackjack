require 'pry'
require './helpers/view_helpers'
require './helpers/controller_helpers'
require 'sinatra'
require 'sinatra/form_helpers'

helpers ViewHelpers
helpers ControllerHelpers

enable :sessions

class Deck
  attr_reader :deck, 
              :player_hand, 
              :dealer_hand, 
              :player_win, 
              :dealer_win, 
              :pvalue, 
              :dvalue

  SUITS = ["Clubs", "Hearts", "Spades", "Diamonds"]
  RANK = ["A", "K", "Q", "J"].concat((2..10).to_a)

  Card = Struct.new(:rank, :value, :suit)

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

  #Check if player's hand beats dealer's.
  def compare_hands
    total_player = get_total_points(get_player_points)
    total_dealer = get_total_points(get_dealer_points)
    total_player > total_dealer
  end

  def dealer_should_hit?
    total_dealer = get_total_points(get_dealer_points)
    total_dealer < 17
  end

  def bust_player
    get_total_points(get_player_points) > 21  || nil
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

  #convert deck to an array
  def to_array
    @deck.map { |card| [card.rank,card.suit] }
  end

  def card_array_to_structs(hand)
    hand.map do |card|
      Card.new(card[0], card[1], card[2])
    end
  end

  def store_player_hand(hand)
    @player_hand = card_array_to_structs(hand)
  end

  def store_dealer_hand(hand)
    @dealer_hand = card_array_to_structs(hand)
  end

end

get "/blackjack" do 

  deck = Deck.new(session['cards'])
  player_hand = nil; dealer_hand = nil
  #Check if hands are already present in the session.
  hands = check_hands(deck, player_hand,dealer_hand)
  deck.compute_value
  outcome = deck.bust_player
  session['cards'] = deck.to_array
  session['player_hand'] = deck.player_hand
  session['dealer_hand'] = deck.dealer_hand

  erb :blackjack, locals: { deck: deck, player_hand: hands[0], dealer_hand: hands[1], outcome: outcome }

end

post "/blackjack/hit" do

  deck = Deck.new(session['cards'])
  deck.store_player_hand(session["player_hand"])
  deck.store_dealer_hand(session["dealer_hand"])
  deck.player_hit
  player_hand = deck.show_rank_suit(deck.get_player_points)
  dealer_hand = deck.show_rank_suit(deck.get_dealer_points)
  outcome = deck.bust_player
  session['player_hand'] = player_hand
  session['dealer_hand'] = dealer_hand
  session['cards'] = deck.to_array

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand, outcome: outcome }

end


get "/blackjack/stay" do
  deck = Deck.new(session['cards'])
  deck.store_player_hand(session["player_hand"])
  deck.store_dealer_hand(session["dealer_hand"])
  session.clear
  outcome = deck.end_game
  player_hand = deck.show_rank_suit(deck.player_hand)
  dealer_hand = deck.show_rank_suit(deck.dealer_hand)

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand, outcome: outcome }
end