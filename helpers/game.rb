require_relative 'constants'
require_relative 'player'

class Game
  attr_reader :dealer_cards, :player_cards, :dealer_pts, :player_pts

  def initialize(bankroll: nil)
    @deck = Constants::DECK.shuffle
    bankroll.nil? ? @player = Player.new : @player = Player.new(bankroll: bankroll)
    @dealer_cards = []
    @player_cards = []
    deal_initial_hands
    @dealer_pts = check_points(@dealer_cards)
    @player_pts = check_points(@player_cards)
  end

  def run
    p @dealer_pts
    p @player_pts
  end

  private

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
      ace_count.times do |index|
        points_array << points - 10 * (index + 1)
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