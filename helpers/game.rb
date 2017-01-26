require_relative 'constants'
require_relative 'player'

class Game
  attr_reader :dealer_cards, :player_cards, :player_cards_2, :dealer_pts, :player_pts, :player_pts_2, :status, :status_2, :dealer_turn, :valid_split, :split_game, :activate_split_cards

  def initialize
    @deck = Constants::DECK.shuffle
    @dealer_cards = []
    @player_cards = []
    deal_initial_hands
    @dealer_pts = check_points(@dealer_cards)
    @player_pts = check_points(@player_cards)
    @dealer_turn = false
    @valid_split = valid_split? #true
    @status = check_blackjack
    # for split games
    @player_cards_2 = []
    @player_pts_2 = nil
    @split_game = false
    @activate_split_cards = false
    @status_2 = nil
  end

  def hit
    if @activate_split_cards && @player_pts_2 != 'blackjack' && @player_pts_2 != 'bust'
      @split_game = false
      @player_cards_2 << @deck.pop
      @player_pts_2 = check_points(@player_cards_2)
      @status_2 = check_bust(@player_pts_2)
      if (@player_pts != 'bust' && @player_pts_2 == 'bust') || @player_pts_2 == 'blackjack'
        @dealer_turn = true
        finish_dealer_turn
        @status = determine_game_result(@player_pts)
        @status_2 = determine_game_result(@player_pts_2)
      end
    elsif @player_pts != 'bust'
      @player_cards << @deck.pop
      @player_pts = check_points(@player_cards)
      @status = check_bust(@player_pts)
      @activate_split_cards = true if @split_game && @player_pts == 'blackjack'
      @activate_split_cards = true if @split_game && @player_pts == 'bust'
    end
  end

  def stay
    if @split_game && @player_cards.size > 1
      @activate_split_cards = true 
    elsif @activate_split_cards && @player_cards_2.size > 1
      @dealer_turn = true
      finish_dealer_turn
      @status = determine_game_result(@player_pts)
      @status_2 = determine_game_result(@player_pts_2) 
    elsif @player_cards.size > 1
      @dealer_turn = true
      finish_dealer_turn
      @status = determine_game_result(@player_pts)
    end
  end

  def split
    #if @valid_split
      @valid_split = false
      @player_cards_2 << @player_cards.pop
      @player_pts = check_points(@player_cards)
      @player_pts_2 = check_points(@player_cards_2)
      @split_game = true
      @status_2 = 'ongoing'
    #end
  end

  private

  def valid_split?
    card_1 = convert_to_point_value(@player_cards[0][0])
    card_2 = convert_to_point_value(@player_cards[1][0])
    return true if card_1 == card_2
    false
  end

  def determine_game_result(player_pts)
    return 'tie' if player_pts == @dealer_pts
    return 'lose' if player_pts == 'bust'
    return 'win' if @dealer_pts == 'bust'
    return 'blackjack' if player_pts == 'blackjack'
    return 'win' if player_pts > @dealer_pts
    'lose'
  end

  def check_bust(player_pts)
    return 'lose' if player_pts == 'bust'
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
      points_array.select! { |sum| sum <= 21 }
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