class Dealer

  attr_reader :hand

  def initialize(hand=[], deck, player)
    @deck = deck
    @hand = hand
    @player = player
  end

  def deal
    @player.hand << @deck.pop
    @hand << @deck.pop
    @player.hand << @deck.pop
    @hand << @deck.pop
  end

  def deal_card_to_player
    @player.hand << @deck.pop
  end

  def deal_card_to_dealer
    @hand << @deck.pop
  end

  def get_dealer_total
    total = [0,0]
    ace = false
    @hand.each do |card|
      ace = true if card[0].upcase == "A"
      if card[0].to_i > 0
        total[0] += card[0].to_i
        total[1] += card[0].to_i
      elsif card[0].upcase == 'A'
        # Two aces are an issue
        total[0] = total[0]+1
        total[1] = total[0]+10
      else
        total[0] += 10
        total[1] += 10
      end
    end
    total = [total[0]] if total[1] > 21 || ace == false
    total
  end

  def get_highest_total
    total_array = get_dealer_total
    if total_array.size == 2
      total = total_array[1]
    else
      total = total_array[0]
    end
    total
  end
end