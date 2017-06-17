class Player
  require 'pry'
  attr_reader :hand

  def initialize(deck, hand_arr = nil)
    @deck = deck

    if hand_arr
      @hand = hand_arr
    else
      @hand = []
      draw(2)
    end
  end

  def blackjack?
    hand.size == 2 && score == 21
  end

  def busted?
    score > 21
  end

  def draw(num = 1)
    num.times { hand.push( @deck.deal ) }
  end

  def score
    total_aces_high = hand.inject(0) do |total, card|
      total + card_score(card)
    end

    if total_aces_high <= 21 || hand.none?{ |card| card[0] == "Ace" }
      total_aces_high
    else #you busted, and you have aces
      try_low_aces
    end

  end

  # returns only those cards face-up on the table
  # i.e: all but the bottom card
  # useful so you can iterate through this collection
  def visible_hand
    hand[1..-1]
  end

  # keep drawing until your score hits the number
  def draw_upto(number)
    draw until score >= 17
  end

  private

  def try_low_aces
    #score aces high
    total = hand.inject(0){|total, card| total + card_score(card)}
    num_aces = hand.count{ |card| card[0] == "Ace" }

    # one by one, bump down aces to 1
    num_aces.times do 
      total -= 10
      return total if total <= 21
    end

    #give up if you're still over 21
    total
  end

  #score of the card
  #scores aces high
  def card_score(card)
    case card[0] #value not type
    when (2..10)
      card[0]
    when "King", "Queen", "Jack"
      10
    when "Ace"
      11
    end
  end

end