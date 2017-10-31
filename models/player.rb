require_relative 'deck'
require './helpers/blackjack_helper.rb'

class Player
  include BlackjackHelper

  attr_accessor :hand, :hand_value, :bankroll

  def initialize(hand: [], hand_value: 0, bankroll: 10)
    @name = "You"
    @hand = hand
    @hand_value = hand_value
    @bankroll = bankroll
  end

  def set_hand_value
    @hand_value = calculate_hand
  end

  def hit(card)
    @hand << card
    calculate_hand
  end

  def subtract_loss(bet)
    @bankroll -= bet
  end

  def add_winnings(bet)
    @bankroll += bet
  end

  def game_ending_hand?
    busted?(@hand_value) || blackjack?(@hand_value)
  end

  def adjust_bankroll(bet)
    subtract_loss(bet) if busted?(@hand_value)
    add_winnings(bet) if blackjack?(@hand_value)
  end

  private

  def calculate_hand
    @hand.reduce(0) do |memo, card|
      value = if card[0].class == Integer
        card[0]
      elsif Deck::FACE_CARDS.include?(card[0])
        10
      else
        1
      end
      memo + value
    end #hand
  end
end

class Dealer < Player

  def initialize(hand: [], hand_value: 0)
    @name = "Dealer"
    @hand = hand
    @hand_value = hand_value
  end

end