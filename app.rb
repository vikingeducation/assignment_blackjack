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
  attr_reader :deck
  attr_accessor :player_hand, 
                :dealer_hand,
                :player_money,
                :wager

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
      @player_money = 1000
      @wager = 0
    end
  end

  def bet(wager)
    @player_money -= wager
    @wager = wager
    @player_money
  end

  def increase_player_money
    @player_money += (@wager * 2)
  end

  def increase_player_money_blackjack
    @player_money += (@wager + (@wager * 1.5))
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
    blackjack_outcome
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
    get_total_points(get_player_points) > 21 ? "Player busts. Dealer wins."  : nil
  end

  def blackjack_tie?
    if @pblackjack && @dblackjack
      @player_money += @wager
      return :tie
    end
  end

  def tie?
    if get_total_points(get_dealer_points) == get_total_points(get_player_points)
      @player_money += @wager
      return "Push"
    end
  end

  #When the player busts or stays
  def end_game
    dealer_hit while dealer_should_hit?
    if get_total_points(get_dealer_points) > 21
      increase_player_money
      return "Dealer busts. Player wins."
    end
    return "Tie" if tie?
    if compare_hands
      increase_player_money
      return "Player wins." 
    else
     return "Dealer wins."
    end
  end

  #Getting points.
  def get_total_points(hand)
    aces = 0
    array = []
    hand.each do |card| 
      if card.value.is_a? Array
        array << card.value[1]
        aces += 1
      else
        array << card.value
      end
    end
    array.sort.reverse.reduce(0) do |m, card|
      if m + card > 21 && aces > 0
        m + 1
        aces -= 1
      else
        m + card
      end
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
    when 'A'
      [1,11]
    when "K", "K", "Q", "J"
      10
    when Fixnum
      card.rank
    end
  end

  def blackjack?(hand)
    return true if hand[0].rank == 'A' && hand[1].value == 10
    return true if hand[1].rank == 'A' && hand[0].value == 10
  end

  def blackjack_outcome
    return "Both players have blackjack" if blackjack_tie?
    if blackjack?(@player_hand)
      increase_player_money_blackjack
      return "Player blackjack"  
    end
    return "Dealer blackjack" if blackjack?(@dealer_hand)
  end

  def show_rank_suit(hand)
    hand.map do |card|
      [card.rank, card.value, card.suit]
    end
  end

end

get "/" do
  erb :bets
end

post "/blackjack" do

  deck = Deck.new(session['cards'])
  deck.player_money = session["player_money"] if session["player_money"]
  player_hand = nil; dealer_hand = nil
  #Check if hands are already present in the session.
  hands = check_hands(deck, player_hand,dealer_hand)
  wager = params[:bet].to_i
  player_money = session["player_money"] || deck.player_money
  player_money -= wager
  session["player_money"] = player_money
  session["bet"] = wager
  session['cards'] = to_array(deck)
  session['player_hand'] = hands[0]
  session['dealer_hand'] = hands[1]
    erb :blackjack, locals: { deck: deck, player_hand: hands[0], dealer_hand: hands[1], outcome: nil, bet: wager, player_money: player_money }

end

post "/blackjack/hit" do

  deck = Deck.new(session['cards'])
  deck.wager = session['bet']
  deck.player_money = session["player_money"]
  store_player_hand(deck, session["player_hand"])
  store_dealer_hand(deck, session["dealer_hand"])
  deck.player_hit
  player_hand = deck.show_rank_suit(deck.get_player_points)
  dealer_hand = deck.show_rank_suit(deck.get_dealer_points)
  outcome = deck.bust_player || nil
  wager = session['bet']
  player_money = session["player_money"]
  if outcome
    session.clear
    session["player_money"] = deck.player_money
    session["bet"] = deck.wager
  else
    store_session(player_hand,dealer_hand,deck, player_money, wager)
  end

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand, outcome: outcome, bet: wager, player_money: player_money }

end


get "/blackjack/stay" do
  deck = Deck.new(session['cards'])
  deck.wager = session['bet']
  deck.player_money = session["player_money"]
  player_money = session["player_money"]
  store_player_hand(deck, session["player_hand"])
  store_dealer_hand(deck, session["dealer_hand"])
  outcome =  deck.end_game || deck.tie?
  wager = session['bet']
  session.clear
  session["player_money"] = deck.player_money
  session["bet"] = deck.wager
  player_hand = deck.show_rank_suit(deck.player_hand)
  dealer_hand = deck.show_rank_suit(deck.dealer_hand)

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand, outcome: outcome, bet: wager, player_money: player_money }
end