module BlackjackHelper

  def load_deck
    CardDeck.new(JSON.parse( session[:deck_arr] ))
  end

  def load_hand(hand)
    JSON.parse(hand)
  end
end