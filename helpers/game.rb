require_relative 'constants'
require_relative 'player'

class Game
  attr_reader :dealer_cards, :player_cards, :dealer_pts, :player_pts, :status

  def initialize
    @deck = Constants::DECK.shuffle
    @dealer_cards = []
    @player_cards = []
    deal_initial_hands
    @dealer_pts = check_points(@dealer_cards)
    @player_pts = check_points(@player_cards)
    @status = check_blackjack
  end

  def hit
    @player_cards << @deck.pop
    @player_pts = check_points(@player_cards)
    @status = check_bust
  end

  def stay
    finish_dealer_turn
    @status = determine_game_result
  end

  def double
  end

  def split
  end

  private

  def determine_game_result
    return 'win' if @dealer_pts == 'bust'
    return 'win' if @player_pts > @dealer_pts
    return 'tie' if @player_pts == @dealer_pts
    'lose'
  end

  def check_bust
    return 'lose' if @player_pts == 'bust'
    'ongoing'
  end

  def check_blackjack
    return 'blackjack' if @player_pts == 'blackjack' && @dealer_pts != 'blackjack'
    return 'lose' if @dealer_pts == 'blackjack' && @player_pts != 'blackjack'
    return 'tie' if @player_pts == 'blackjack' && @player_pts == @dealer_pts
    'ongoing'
  end

  def finish_dealer_turn
    while @dealer_pts.is_a?(Integer) && @dealer_pts <= 16
      @dealer_cards << @deck.pop
      @dealer_pts = check_points(@dealer_cards)
    end
  end

  def check_points(cards_array)
    points = 0
    ace_count = 0
    cards_array.each do |card|
      points += convert_to_point_value(card[0]) 
      ace_count += 1 if card[0] == 'A'
    end
    return 'blackjack' if points == 21 && cards_array.size == 2
    if ace_count > 0 
      points_array = []
      points_array << points
      ace_count.times do |i|
        points_array << points - 10 * (i + 1)
      end
      points_array.select! { |sum| sum < 21 }
      return 'bust' if points_array.empty?
      return points_array.max
    end
    return 'bust' if points > 21
    points
  end

  def convert_to_point_value(card_rank)
    return card_rank.to_i if %w(2 3 4 5 6 7 8 9 10).include?(card_rank)
    return 10 if %w(J Q K).include?(card_rank)
    return 11 if card_rank == 'A'
  end

  def deal_initial_hands
    2.times do
      @player_cards << @deck.pop
      @dealer_cards << @deck.pop
    end
  end
end