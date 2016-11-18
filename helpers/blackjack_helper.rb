module BlackjackHelper
  POINTS = {'J' => 10, 'K' => 10, 'Q' => 10, 'A' => 11 }

  def game_start
    player_cards = [draw_from_deck,draw_from_deck]
    dealer_cards = [draw_from_deck,draw_from_deck]
    save_cards(player_cards,dealer_cards)
  end

  def hit_me(cards)
    cards << draw_from_deck
  end

  def get_points(cards)
    cards.map do |card|
      if POINTS[ card[0] ].nil?
        card[0].to_i
      else
        POINTS[ card[0] ]
      end
    end
  end

  def blackjack?(cards)
    sum_points( cards ) == 21
  end

  def busted?(cards)
    sum_points( cards ) > 21
  end

  def sum_points(cards)
    points = get_points(cards)

    ace_i = 0
    while points.inject(:+) > 21 && !!ace_i
      ace_i = points.find_index(11)
      points[ace_i] = 1 unless ace_i.nil?
    end

    points.inject(:+)
  end

  def premature_win?
    blackjack?(session['player_cards']) ||
    blackjack?(session['dealer_cards']) ||
    busted?(session['player_cards'])
  end

  def get_outcome
    return 'lost' if lost?
    return 'won' if won?
    return 'draw'
  end

  def won?
    return false if busted?(session['player_cards'])
    busted?(session['dealer_cards']) ||
    sum_points(session['player_cards']) >
    sum_points(session['dealer_cards'])
  end

  def lost?
    return false if busted?(session['dealer_cards'])
    busted?(session['player_cards']) ||
    sum_points(session['player_cards']) <
    sum_points(session['dealer_cards'])
  end

  def draw?
    sum_points(session['player_cards']) ==
    sum_points(session['dealer_cards'])
  end

end
