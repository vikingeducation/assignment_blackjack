module Sessions
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

  def load_player(session)
    player = JSON.parse(session)
    player.delete('hand')
    player.delete('bet')
    player
  end

  def set_up_player(player)
    player = Player.new(player.to_json)
    save_player('player', player)
  end
end
