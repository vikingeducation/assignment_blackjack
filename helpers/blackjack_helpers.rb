require 'sinatra/reloader'

module BlackjackHelpers

  def add_card
    values = (2..11).to_a
    card = values.sample
    card
  end

  def deal
    hand = []
    2.times do
      hand << add_card
    end
    if hand[0] == 11 && hand[1] == 11
      hand[0] = 1
    end
    hand
  end

  def hit(player)
    session[player.to_sym] << add_card
  end

  def stay
    session[:turn] = "dealer_hand"
    total = hand_total(session[:dealer_hand])
    until total >= 17
      hit(session[:turn])
      total = hand_total(session[:dealer_hand])
    end
  end

  def bet
    #
  end

  def reset_bank
    10_000
  end

  def bust?(player)
    this_hand = session[player]
    sum = hand_total(this_hand)
    this_hand[this_hand.index(11)] = 1 if sum > 21 && this_hand.include?(11)
    !!(hand_total(this_hand) > 21)
  end

  def hand_total(hand)
    hand.inject { |total, card| total += card }
  end

  def status_message(message)
    session[:message] = message
  end

  def ace_value

  end

  def twenty_one?(player)
    !!(hand_total(session[player.to_sym]) == 21)
  end

  def update_bank

  end

  def reset_hands
    session[:player_hand] = deal
    session[:dealer_hand] = deal
  end

end
