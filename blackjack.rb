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

  def non_ace_value(user)
    sum = 0
    user.hand.each do |card|
      if card[0] != 1 && card[0] < 10
        sum += card[0]
      elsif card[0] >= 10
        sum += 10
      end
    end
    return sum
  end

  def aces(user)
    count = 0
    user.hand.each do |card|
      if card[0] == 1
        count += 1
      end
    end
    count
  end

  def hand_value(user)
    return non_ace_value(user) if aces(user) == 0
    low = non_ace_value(user) + aces(user)
    high = non_ace_value(user) + 11 + aces(user) - 1
    high < 22 ? high : low
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

  def blackjack? 
    if hand_value(@player) == 21
      return true
    else
      return false
    end
  end

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
