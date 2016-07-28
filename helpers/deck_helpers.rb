module DeckHelper
  BLACKJACK_AMT = 21

  def create_deck
    suits = ['H', 'D', 'S', 'C']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    session[:deck] = suits.product(values).shuffle!
    session[:dealer_cards] = []
    session[:player_cards] = []
    2.times { deal_dealer ; deal_player }
  end

  def dealer_hand
    session[:dealer_cards]
  end

  def player_hand
    session[:player_cards]
  end

  def deal_dealer
    session[:dealer_cards] << session[:deck].pop
  end

  def deal_player
    session[:player_cards] << session[:deck].pop
  end

  def calculate_total(cards)
    # [['H', '3'], ['S', 'Q'], ... ]
    arr = cards.map{|e| e[1] }
    total = 0
    arr.each do |value|
      if value == "A"
        total += 11
      elsif value.to_i == 0 # J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end

    #correct for Aces
    arr.select{|e| e == "A"}.count.times do
      total -= 10 if total > 21
    end
    total
  end

  def player_busted?
    calculate_total(session[:player_cards]) > 21
  end

  def dealer_busted?
    calculate_total(session[:dealer_cards]) > 21
  end

  def player_count
    calculate_total(session[:player_cards])
  end

  def busted_player
    return "Player" if player_busted?
    return "Dealer" if dealer_busted?
  end

  def dealer_count
    calculate_total(session[:dealer_cards])
  end

  def compare_hands
    if player_count > 21
      "Dealer"
    elsif dealer_count > 21
      "Player"
    elsif player_count > dealer_count
      "Player"
    elsif player_count <  dealer_count
      "Dealer"
    else
      nil
    end
  end

end