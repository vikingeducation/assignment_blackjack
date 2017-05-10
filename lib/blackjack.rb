require_relative './card.rb'
require_relative './hand.rb'

class Blackjack

  attr_accessor :player_hand, :dealer_hand, :player_bankroll, :player_bet

  def initialize(player_hand = Hand.new,dealer_hand = Hand.new, player_bankroll = 1000, player_bet=0)
    @player_hand = player_hand
    player_hand.name = "Player Hand"
    @player_bankroll = player_bankroll
    @player_bet = player_bet
    @dealer_hand = dealer_hand
    dealer_hand.name = "Dealer Hand"
  end

  SUITS = {
    'Spades' => "S",
    'Diamonds' => "D",
    'Clubs' => "C",
    'Hearts' => 'H'
  }

  RANKS = {
    'A' => "A",
    '2' => "2",
    '3' => "3",
    '4' => "4",
    '5' => "5",
    '6' => "6",
    '7' => "7",
    '8' => "8",
    '9' => "9",
    '10' => "T",
    'J' => "J",
    'Q' => "Q",
    'K' => "K"
  }

  VALUES = {
    'A' => 11,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10
  }

  def percent_bet
    (@player_bet / @player_bankroll.to_f) * 100
  end

  def percent_bank
    100 - percent_bet
  end

  def place_bet(amount)
    return false if amount > @player_bankroll || amount <= 0
    @player_bet = amount
  end

  def can_double?
    @player_hand.cards.size == 2 && @player_bet * 2 <= @player_bankroll
  end

  def double
    @player_bet *= 2
    deal(@player_hand)
  end

  def random_card
    Card.new(rank: RANKS.keys.sample, suit: SUITS.keys.sample)
  end

  def first_deal
    2.times do
      deal(@player_hand)
      deal(@dealer_hand)
    end
  end

  def deal(player)
    player.cards << random_card
  end

  def resolve_bet
    case winner
    when :player
      @player_bankroll += @player_bet
    when :dealer
      @player_bankroll -= @player_bet
    end
  end

  def dealers_turn
    return if winner == :dealer
    while @dealer_hand.best_value < 17 || @dealer_hand.best_value == 17 && @dealer_hand.hard_value < 17
      deal(@dealer_hand)
    end
  end

  def winner
    player_value = @player_hand.best_value
    dealer_value = @dealer_hand.best_value
    if player_value > 21
      :dealer
    elsif dealer_value > 21
      :player
    elsif  dealer_value > player_value
      :dealer
    elsif  dealer_value < player_value
      :player
    else
      :draw
    end
  end
end
