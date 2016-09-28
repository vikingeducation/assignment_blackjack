module DeckHelper

  def create_deck
    @deck = []
    suits = ['Hearts', 'Spades', 'Clubs', 'Diamonds']
    values = %w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King]
    @deck = suits.product(values).shuffle!
  end

  def deal_card
    @deck.pop
  end

  def new_hand
    @winner = nil
    @player_hand = []
    @dealer_hand = []
    @player_hand << deal_card
    @dealer_hand << deal_card
    @player_hand << deal_card
    @dealer_hand << deal_card
    session[:deck] = @deck
    session[:dealer_hand] = @dealer_hand
    session[:player_hand] = @player_hand
  end

  def player_total
    calculate_total(session[:player_hand])
  end

  def dealer_total
    calculate_total(session[:dealer_hand])
  end

  def player_hit
    session[:player_hand] << session[:deck].pop
  end

  def dealer_hit
    session[:dealer_hand] << session[:deck].pop
  end

  def player_busted?
    player = player_total
    if player > 21
      return true
    end
    false
  end

  def dealer_busted?
    dealer = dealer_total
    if dealer > 21
      return true
    end
    false
  end

  def player_blackjack?
    if player_total == 21
      return true
    end
    false
  end

  def dealer_blackjack?
    if dealer_total == 21
      return true
    end
    false
  end

  def compare_hands
    player = player_total
    dealer = dealer_total
    if player > 21
      @winner = "dealer"
    elsif dealer > 21
      @winner = "player"
    elsif player > dealer
      @winner = "player"
    elsif player == dealer
      @winner = "tie"
    elsif dealer > player
      @winner = "dealer"
    end
  end

  def calculate_total(hand)
    total = 0
    aces = 0
    hand.each do |card_value|
      if card_value[1] == 'Ace'
        total += 11
        aces += 1
      elsif card_value[1] == 'King' || card_value[1] == 'Queen' || card_value[1] == 'Jack'
        total += 10
      else
        total += card_value[1].to_i
      end
    end
    aces.times do
      if total > 21
        total -= 10
      end
    end
    return total
  end

end