require_relative 'card'
require_relative 'hand'
require_relative 'dealer'

class Blackjack

  attr_reader :player_hand, :dealer_hand

  SUITS = ["H", "S", "C", "D"]

  VALUES = {
  "A": 11,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "10": 10,
  "J": 10,
  "Q": 10,
  "K": 10
  }

  def initialize(player_hand, dealer_hand, bank)
    player_hand ||= []
    dealer_hand ||= []
    @deck = {}
    @player_hand = Hand.new(player_hand, bank)
    @dealer_hand = Dealer.new(dealer_hand)
    build_deck()
    start_game if player_hand.empty?
    #@over = false
  end

  def give_card(player)
    face = @deck.keys.sample
    suit = @deck[face].sample
    delete(face, suit)
    player.add_card(face, suit)
  end

  def dealer_play
    give_card(@dealer_hand) while @dealer_hand.decide_hit?
    end_game
  end

  def end_game
    if win?
      return "player"
    elsif tie?
      return "tie"
    elsif lose?
       return "dealer"
    end
  end

  def update_bank(bet)
     if win?
      @player_hand.make_bank(bet)
      elsif lose?
       @player_hand.lose_bank(bet)
    end
  end

  def over?
    @player_hand.busted? || @player_hand.hand_value == 21 || @dealer_hand.busted?
  end

  def save
    save = {}
    dealer = @dealer_hand.cards.map { |card| [card.face, card.suit] }
    player = @player_hand.cards.map { |card| [card.face, card.suit] }
    save["dealer"] = dealer
    save["player"] = player
    save
  end


  def start_game
    2.times do
      give_card(@player_hand)
      give_card(@dealer_hand)
    end
  end

  def build_deck
    VALUES.keys.each do |key|
      @deck[key] = SUITS.dup
    end

    @player_hand.cards.each {|card| delete(card.face, card.suit)}
    @dealer_hand.cards.each {|card| delete(card.face, card.suit)}
  end

  def delete(face, suit)
    @deck[face].delete(suit)
    @deck.delete(face) if @deck[face].empty?
  end

  def tie?
    (@player_hand.busted? && @dealer_hand.busted?) || (@player_hand.hand_value == @dealer_hand.hand_value)
  end

  def win?
    ((@player_hand.hand_value > @dealer_hand.hand_value) || @dealer_hand.busted?) && !@player_hand.busted?
  end

  def lose?
    ((@player_hand.hand_value < @dealer_hand.hand_value) || @player_hand.busted?) && !@dealer_hand.busted?
  end
end
