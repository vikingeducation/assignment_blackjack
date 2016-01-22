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
    user.hand.inject(0) do |sum, card|
      if card[0] >= 10
        sum += 10
      else
        sum += card[0]
      end
    end
  end

  def has_won?

  end

  def bust?(user)
    hand_value(user) > 21
  end

  def double(user, bet_amount)
    if user.has_bankroll?(bet_amount * 2)
      user.hand << @deck.pick_card
      return true
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
    elsif bust?(@dealer) || hand_value(@dealer) < hand_value(@player) 
      @player.bankroll += bet * 2
    end
  end

end
