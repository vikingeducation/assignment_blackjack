# ./helpers/checkers_helper.rb

module BlackjackHelper

  def not_new_game?
    !!(session["deck_arr"])
  end
#returns deck_arr (arr) from session
  def load_deck
    Deck.new(session["deck_arr"]).deck_arr
  end

#takes deck_arr and saves it to session hash
  def save_deck(deck_arr)
    session["deck_arr"] = deck_arr
  end

#returns player_hand (arr) from session
  def load_hand
    Hand.new(session["player_hand_arr"]).hand_arr
  end

#takes player_hand and saves it to session hash
  def save_hand(player_hand)
    session["player_hand_arr"] = player_hand
  end

  def load_dealer_hand
    Hand.new(session["dealer_hand_arr"]).hand_arr
  end

  def save_dealer_hand(dealer_hand)
    session["dealer_hand_arr"] = dealer_hand
  end

  def get_dealer_moves
    dealer_hand = Hand.new(load_dealer_hand)
    deck = Deck.new(session["deck_arr"])
    dealer_hand.hit(deck.deal) until dealer_hand.score > 17
    dealer_hand = save_dealer_hand(dealer_hand.hand_arr)
    deck = save_deck(deck.deck_arr)
  end

  def deal_two_cards
    hand = []
    deck = Deck.new(load_deck)
    hand << deck.deal
    hand << deck.deal
    save_deck(deck.deck_arr)
    hand
  end

end

