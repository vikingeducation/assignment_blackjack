# ./helpers/checkers_helper.rb

module BlackjackHelper

  def save_deck(board)
  end

  def load_deck
    Deck.new( JSON.parse( session["deck_arr"] ) )
  end


end

