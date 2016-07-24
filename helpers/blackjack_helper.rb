# ./helpers/checkers_helper.rb

module BlackjackHelper
  def new_game?
    !session["bank"]
  end

  def new_round?
    !(session["deck_arr"])
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

  def hit_player
    deck = Deck.new(load_deck)
    card = deck.deal
    deck = save_deck(deck.deck_arr)
    player_hand = save_player_hand(Hand.new(load_player_hand).hit(card))
  end

  def initialize_round
    save_player_hand(Hand.new(deal_two_cards).hand_arr)
    save_dealer_hand(Hand.new(deal_two_cards).hand_arr)
    save_deck( Deck.new.deck_arr )
    save_dealer_score(Hand.new(load_dealer_hand).score)
    save_player_score(Hand.new(load_player_hand).score)
  end

  def load_round
    deck = load_deck
    player_hand = load_player_hand
    dealer_hand = load_dealer_hand
    player_score = load_player_score
    dealer_score = load_dealer_score
  end


  def who_won(dealer_score, player_score)
    if dealer_score == player_score
      "Tie"
    elsif dealer_score > 21 || player_score > dealer_score
      "You"
    else
      "Dealer"
    end
  end

  def calculate_bank(bank, bet, who_won)
    if Hand.new(load_player_hand).blackjack?
      save_bank(bank.to_f + (1.5 * bet.to_f))

    elsif who_won == "You"
      save_bank(bank + bet)

    elsif who_won == "Dealer"
      save_bank(bank - bet)
    else who_won == "Tie"
      save_bank(bank)
    end

  end

end

