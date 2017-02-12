
module BJHelper

  class Player

    def initialize(session_hash)
    end

  end

  class Dealer

    def initialize(session_hash)
    end

  end

  def save_dealer_hand(dealer_hand)
    session[:dealer_hand] = dealer_hand.to_json
  end

  def save_player_hand(player_hand)
    session[:player_hand] = player_hand.to_json
  end

  def save_the_deck(deck)
    session[:deck] = deck.to_json
  end

  def load_player_hand
    session[:player_hand] ? JSON.parse(session[:player_hand],:quirks_mode => true) : [deal_hand(create_deck), deal_hand(create_deck)]
  end

  def load_dealer_hand
    puts "DBG: session[:dealer_hand] = #{session[:dealer_hand].inspect}"
    session[:dealer_hand] ? JSON.parse(session[:dealer_hand],:quirks_mode => true) : [deal_hand(create_deck), deal_hand(create_deck)]
  end

  def load_the_deck
    create_deck
    # session[:deck]  ? JSON.parse(session[:deck],:quirks_mode => true) : create_deck
  end

  def creating_deck
    [2,3,4,5,6,7,8,9,10, "J", "Q", "K", "A"].product(["Diamonds", "Hearts", "Clubs", "Spades"])
  end


  def create_deck
    the_deck = []
    4.times { |i| the_deck += creating_deck }
    the_deck.shuffle
  end

  def deal_hand(deck)
    deck.pop
  end

  #we need current_hand of player

  def check_who_won(player_hand, dealer_hand)
    if checking_points(player_hand) <= 21 && checking_points(dealer_hand) <= 21
      checking_points(player_hand) <=> checking_points(dealer_hand)
    elsif checking_points(player_hand) > 21
      -1
    else
      1
    end
  end

  def dealer_deals(current_hand)
    points = checking_points(current_hand)
    deal_hand(create_deck) if points[0] + points[1] < 17
  end

  def checking_points(current_hand)
    total = 0
    as_value = 0
    current_hand.each do |arr|
      if %w{J K Q}.include? arr[0]
        total += 10
      elsif "A" == arr[0]
        total += 1
        as_value += 10
      else
        total += arr[0]
      end
    end
    if total <= 11
      total += 10 if as_value != 0
    else
      return total
    end
    total
  end

end