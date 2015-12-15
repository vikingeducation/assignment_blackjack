module BlackjackHelper

  def load_deck
    CardDeck.new(JSON.parse( session[:deck_arr] ))
  end

  def load_hand(hand)
    JSON.parse(hand)
  end

  def set_winner_and_scores(player_hand, dealer_hand)
    player_score = @deck.best_score(@deck.hand_values(player_hand))
    dealer_score = @deck.best_score(@deck.hand_values(dealer_hand))
    scores_arr = [player_score, dealer_score]

    winner = @deck.winner(scores_arr)

    session[:scores] = scores_arr.to_json
    session[:winner] = winner
  end
end