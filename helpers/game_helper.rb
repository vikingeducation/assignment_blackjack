require 'json'

module GameHelper

  def save_game(deck, dealer_hand, player_hand)
    session[:deck] = deck.to_json
    session[:dealer_hand] = dealer_hand.to_json
    session[:player_hand] = player_hand.to_json
  end

  def load_game
    {
      deck: JSON.parse(session[:deck]),
      dealer_hand: JSON.parse(session[:dealer_hand]),
      player_hand: JSON.parse(session[:player_hand])
    }
  end
end
