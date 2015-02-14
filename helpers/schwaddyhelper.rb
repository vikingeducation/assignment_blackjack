module Schwaddyhelper

  def lets_deal#(num_to_deal_to)
    @shuffle_up = (JSON.parse(session[:original_deck])).sample(18)
    @deal = @shuffle_up.pop(2)  #gets two decks off
    session[:dealer_hand] = @deal[0].to_json
    session[:player_hand] = @deal[1].to_json
    session[:shuffle_up] = @shuffle_up.to_json
    # @my_current_deck = ["hi"]#JSON.parse(session[:original_deck])
    # session[:current_deck] = @my_current_deck.to_json
    # @deal << @my_original_deck.sample(num_to_deal_to)
    # @my_current_deck = @my_original_deck - @deal
    # return @deal
  end

  def adder(input)
    card_hash = {
      "2" => 2,
      "3" => 3,
      "4" => 4,
      "5" => 5,
      "6" => 6,
      "7" => 7,
      "8" => 8,
      "9" => 9,
      "10" => 10,
      "Jack" => 10,
      "Queen" => 10,
      "King" => 10,
      "Ace" => 11
    }
    total_score = 0
    input.each do |card|
      total_score += card_hash[card]
    end


    return total_score
  end
end