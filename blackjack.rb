require './cards.rb'
require './dealer.rb'
require './player.rb'

class Blackjack
  attr_accessor :player, :dealer, :deck
  attr_reader :turn

  def initialize
    @deck = Cards.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def deal(user)
    user.hand << @deck.pick_card
    user.hand << @deck.pick_card
  end

  def new_hand
    deal(@dealer)
    deal(@player)
  end

  def hand_value(user)
    user.hand.inject(0) { |sum, card| sum += card[0] }
  end

  def has_won?

  end

  def bust?(user)
    user.hand_value > 21
  end

  def double(user, bet_amount)
    if user.has_bankroll?(bet_amount * 2)
      user.hand << @deck.pick_card
      user.bet *= 2
      stay
    else
      return false
    end
  end

  def hit(user)
    user.hand << @deck.pick_card
  end

  def split(user)

  end

  # def blackjack?

  # end

  def stay(bet)
    until hand_value(@dealer) >= 17
      hit(@dealer)
    end
    if hand_value(@dealer) == hand_value(@player)
      @player.bankroll += bet
    elsif hand_value(@dealer) < hand_value(@player)
      @player.bankroll += bet * 2
    end
  end

end
