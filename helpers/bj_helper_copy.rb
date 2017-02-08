
require 'json'

module BJHelper

  #we need to store the status of the deck
  
  #we neeed current_hand of dealer

  def save_dealer_hand(dealer_hand)
    session[:dealer_hand] = dealer_hand
  end

  def save_player_hand(player_hand)
    session[:player_hand] = player_hand
  end

  def save_the_deck(deck)
    session[:deck] = deck
  end

  def load_player_hand
    session[:player_hand] ? session[:player_hand] : [deal_hand(create_deck), deal_hand(create_deck)]
  end

  def load_dealer_hand
    puts "DBG: session[:dealer_hand] = #{session[:dealer_hand].inspect}"
    puts "DBG: session[:dealer_hand]) = #{session[:dealer_hand].inspect}"
    session[:dealer_hand] ? session[:dealer_hand] : [deal_hand(create_deck), deal_hand(create_deck)]
  end

  def load_the_deck
    puts "DBG: session[:deck] = #{session[:deck].inspect}"
    session[:deck] ? session[:deck] : create_deck
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

  def dealer_deals(current_hand)
    points = checking_points(current_hand)
    deal_hand(create_deck) if points[0] + points[1] < 17
  end

  def checking_points(current_hand)
    total = 0
    as_value = 0
    puts "DBG: current_hand = #{current_hand.inspect}"
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
    [total, as_value]
  end

end