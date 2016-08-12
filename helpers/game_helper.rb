module GameHelper

  def read_deck
    JSON.parse( session[:deck] )
  end

  def read_player_cards
    JSON.parse( session[:player_cards] )
  end

  def read_dealer_cards
    JSON.parse( session[:dealer_cards] )
  end

  def save_deck deck
    session[:deck] = deck.to_json
  end

  def save_player_cards cards
    session[:player_cards] = cards.to_json
  end

  def save_dealer_cards cards
    session[:dealer_cards] = cards.to_json
  end

  def initialize_sessions
    initialize_deck
    initialize_player_cards
    initialize_dealer_cards
  end

  def initialize_deck
    session[:deck] = [].to_json if session[:deck].nil?
  end

  def initialize_player_cards
    session[:player_cards] = [].to_json if session[:player_cards].nil?
  end

  def initialize_dealer_cards
    session[:dealer_cards] = [].to_json if session[:dealer_cards].nil?
  end

  def deck_full? deck
    deck.cards.length == 52
  end

  def shuffle_cards deck, player
    2.times { deck.deal_card player }
  end

end
