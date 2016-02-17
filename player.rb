class Player

  attr_accessor :hand

  def initialize(hand=[])
    @hand = hand
  end

  def get_player_total
    total = [0,0]
    ace = false
    @hand.each do |card|
      ace =true if card[0].upcase == "A"
      if card[0].to_i > 0
        total[0] += card[0].to_i
        total[1] += card[0].to_i
      elsif card[0].upcase == 'A'
        # Two aces are an issue
        total[0] += 1
        total[1] = total[0]+10
      else
        total[0] += 10
        total[1] += 10
      end
    end
    # This is done for display purposes, no need to show the option where ace counts for 11 if it's gone over 21.
    total = [total[0]] if total[1] > 21 || ace == false
    total
  end
end