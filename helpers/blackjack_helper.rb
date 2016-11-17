module BlackjackHelper

  def game_start
    player_cards = [draw_from_deck,draw_from_deck]
    dealer_cards = [draw_from_deck,draw_from_deck]
    [player_cards, dealer_cards]
  end

  def hit_player
    player_cards = (session["player_cards"] << draw_from_deck)
    dealer_cards = session["dealer_cards"]
    save_cards(player_cards,dealer_cards)
    [player_cards,dealer_cards]
  end

  def has_won?
    false
  end

  def busted?

  end
end