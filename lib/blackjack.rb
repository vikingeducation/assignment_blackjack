require_relative 'deck'


class Blackjack

  FACE_CARDS = ['J', 'Q', 'K']

  attr_reader :dealers_hand, :players_hand, :deck

  def initialize(deck=nil)
    @deck = Deck.new
    @deck.create_shoe if deck.nil?
    @deck.shoe = deck unless deck.nil?

  end

  def start_game
    @dealers_hand = []
    @players_hand = []
    2.times do
      @players_hand << @deck.deal_card
      @dealers_hand << @deck.deal_card
    end
    [@dealers_hand, @players_hand]
  end

  def check_blackjack(dealer, player)
    if calculate_score(player) == 21
      outcome = "player21"
    elsif calculate_score(dealer) == 21
      outcome = 'dealer21'
    elsif calculate_score(player) == 21 && calculate_score(dealer) == 21
      outcome = 'tie'
    else
      outcome = nil
    end
    outcome
  end

  def calculate_score(hand)
    total = 0
    hand.each do |card|
      if FACE_CARDS.include?(card)
        total += 10
      elsif (2..10).include?(card.to_i)
        total += card.to_i
      end
    end
    if hand.include?("A")
    # if hand is less than or equal 10, A = 11
      if total <= 10
        total += 11
      else
        total += 1
      end
    end
    total
  end


  def dealer_hit(hand)
    score = calculate_score(hand)
    until score >= 17
      hit(hand)
       score = calculate_score(hand)
    end
    hand
  end


  def outcome(dealer, player)
    dealer_score = calculate_score(dealer)
    player_score = calculate_score(player)
    if player_score > dealer_score
      outcome = "win"
      # process_win
    elsif player_score == dealer_score
      outcome = "tie"
    else
      outcome = "loss"
    end
    outcome
  end


  def bust?(hand)
    calculate_score(hand) > 21
  end


  def hit(hand)
    hand << @deck.deal_card
  end


  def split
    first_pair = []
    second_pair = []
    if @players_hand.size == 2
      first_pair << @players_hand[0]
      first_pair << @deck.deal_card
      second_pair << @players_hand[1]
      second_pair << @deck.deal_card
      @players_hand = [first_pair, second_pair]
    end
  end


  def get_shoe
    @deck.shoe
  end

end