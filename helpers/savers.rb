module Savers
  def save_deck(deck)
    session['deck'] = deck.cards.to_json
  end

  def save_player(n, player)
    bundle = { 'hand' => player.hand,
               'bank' => player.bank,
               'bet' => player.bet,
               'status' => player.status}
    session[n] = bundle.to_json
  end

end
