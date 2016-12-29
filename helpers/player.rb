class Player

  attr_accessor :bankroll, :bet
  attr_reader :cards

  def initialize(cards, bankroll=nil, bet=nil)
    @cards = cards
    @bankroll = bankroll ? bankroll : 1000
    @bet = bet
  end

  def valid?(bet)
    if bet <= @bankroll
      place_bet(bet)
      return true
    else
      return false
    end
  end

  def place_bet(bet)
      @bankroll -= bet
      @bet = bet
    end

  def sum
    values = @cards.map { |card| card.value }
    sum = 0
    values.each do |value|
      if value == "A"
        sum += 1
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end
    values.each do |value|
      sum += 10 if elevent_point_ace?(value, sum)
    end
    sum
  end

  def elevent_point_ace?(value, sum)
    value == "A" && sum < 12
  end

  def wins
    @bankroll += (bet * 2)
  end

  def ties
    @bankroll += bet
  end


end