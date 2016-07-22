require 'json'

module GameHelper
  VALUE = {}
  "2".upto("10") {|num| VALUE[num] = num.to_i }
  VALUE["Ace"] = 11
  VALUE["King"] = 10
  VALUE["Queen"] = 10
  VALUE["Jack"] = 10

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

  def hand_total(hand)
    hand.inject(0) do |sum, card|
      binding.pry
      sum + VALUE[card[1]]
    end
  end
end
