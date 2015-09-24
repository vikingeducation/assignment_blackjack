require_relative 'card'
require_relative 'deck'
require 'pry-byebug'

class Player
  attr_accessor :hand
  def initialize(hand = nil)
    @hand = hand
  end

  def hit(card)
    @hand << card
  end

  def hand_sum
    # binding.pry
    sum = 0
    num_aces = 0
    #binding.pry
    @hand.each do |card|
      val = 0
      if ["K","Q","J"].include? card.value
        val = 10
      elsif card.value == "A"
        num_aces += 1
      else
        val = card.value.to_i
      end
      sum += val
    end

    aces_value = 0
    #adding aces
    #ex. if you have 8 and three aces, then you can have one ace as 11 and two as 1 => 8 + 11 + 2*1 + 21
    if sum + num_aces > 11
      aces_value = num_aces
    elsif num_aces > 0
      aces_value = 11 + (num_aces-1)
    end

    sum += aces_value
  end

  def hand_to_s
    s = ""
    @hand.each do |card|
      s += "[#{card.value}#{card.suit}]"
    end
    s
  end
end

# d = Deck.new
# hand = [Card.new(5,'c'),Card.new(6,'c')]
# p = Player.new(hand)
# print "#{p.hand_to_s} => #{p.hand_sum}\n"
# p.hit(d.pop)
# print "#{p.hand_to_s} => #{p.hand_sum}\n"
# p.hit(d.pop)
# print "#{p.hand_to_s} => #{p.hand_sum}\n"
