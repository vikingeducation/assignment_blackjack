module BlackJackHelpers

  SCORES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10,
    'A' => 11
  }

  def build_deck
    face = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
    suit = ["hearts", "spades", "clubs", "diamonds"]
    @deck = face.product(suit)
  end

  def deal_cards(num_of_cards)
    hand = @deck.sample(num_of_cards)
    hand.each do |card_in_hand|
      @deck.delete_if { |card_in_deck| card_in_deck == card_in_hand }
    end
    hand
  end

  def save_variables
    session[:dealer] = @dealer
    session[:player] = @player
    session[:deck] = @deck
  end

  def restore_variables
    @dealer = session[:dealer]
    @player = session[:player]
    @deck = session[:deck]
  end

  def get_player_score(player)
    score = player.reduce(0) do |s, i|
      s += SCORES[i[0].to_s]
    end
    if score > 21 && player.any? {|x| x[0] == "A"}
      score = score - 10
    end
    score
  end


end
