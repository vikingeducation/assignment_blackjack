require 'sinatra/reloader'

module BlackjackHelpers

  def add_card
    values = (1..11).to_a
    card = values.sample
    card
  end

  def deal
    hand = []
    2.times do
      hand << add_card
    end
    hand
  end

  def hit(player)
    session[player.to_sym] << add_card
  end

  def stay
    session[:turn] = "dealer_hand"
  end

  def bet
    #
  end

  def reset_bank
    10_000
  end

  def bust?(player)
    !!(hand_total(session[player.to_sym]) > 21)
  end

  def hand_total(hand)
    hand.inject { |total, card| total += card }
  end

  def status_message(message)
    session[:message] = message
  end

end
