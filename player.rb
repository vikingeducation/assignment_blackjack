require 'pry'
class Player
  attr_accessor :name, :hand
  def initialize(name, hand)
    @name = name
    @hand = hand
  end

  def deal(deck)
    @hand << deck.pop
  end

  def busted?
    calculate_total > 21
  end

  def calculate_total
    lcl_hand = hand
    arr = lcl_hand.map{|e| e[1] }
    total = 0
    arr.each do |value|
      if value == "A"
        total += 11
      elsif value.to_i == 0 # J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end
    #correct for Aces
    arr.select{|e| e == "A"}.count.times do
      total -= 10 if total > 21
    end
    total
  end
end