module Savers
  def save_deck(deck)
    session['deck'] = deck.to_json
  end

  def save_hand(n, player)
    session[n] = player.hand.to_json
  end
end
