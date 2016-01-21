module CardHelper

  def img_file(card_array)
    card_hash = {1 => "ace", 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9', 10 => '10', 11 => "jack", 12 => "queen", 13 => "king"}
    return "img/#{card_hash[card_array[0]]}_of_#{card_array[1]}.svg"
  end

  def get_hand(hand)
    hand.map {|card| img_file(card)}
  end
  
  def load_game
    game = Blackjack.new
    game.new_hand
    player_hand = get_hand(game.player.hand)
    dealer_hand = get_hand(game.dealer.hand)
  end
end
