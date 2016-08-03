module DeckHelper
  BLACKJACK_AMT = 21

  def create_deck(params = {})
    @deck = Deck.new
    @dealer = Player.new("Dealer", [])
    @player = Player.new("Player", [])
    session[:deck] = @deck.cards
    session[:dealer_cards] = @dealer.hand
    session[:player_cards] = @player.hand
    session[:player_bankroll] = @player.bankroll if params[:reset_bankroll]
    2.times { deal_dealer ; deal_player }
  end

  def new_hand
    @dealer = Player.new("Dealer", [])
    @player = Player.new("Player", [])
    session[:dealer_cards] = @dealer.hand
    session[:player_cards] = @player.hand
    2.times { deal_dealer ; deal_player }
  end

  def reset_bankroll
    session[:player_bankroll] = Player.new("Player", []).bankroll
  end

  def dealer_hand
    Player.new("Dealer", session[:dealer_cards]).hand
  end

  def player_hand
    Player.new("Player", session[:player_cards]).hand
  end

  def deal_dealer
    session[:dealer_cards] << Deck.new(session[:deck]).pop
  end

  def deal_player
    session[:player_cards] << Deck.new(session[:deck]).pop
  end

  def player_busted?
    Player.new("Player", session[:player_cards]).busted?
  end

  def dealer_busted?
    Player.new("Dealer", session[:dealer_cards]).busted?
  end

  def player_count
    Player.new("Player", session[:player_cards]).calculate_total
  end

  def dealer_count
    Player.new("Dealer", session[:dealer_cards]).calculate_total
  end

  def busted_player
    return "Player" if player_busted?
    return "Dealer" if dealer_busted?
  end

  def set_player_bet(amount)
    session[:player_bet] = amount
    session[:player_bankroll] = session[:player_bankroll].to_i - amount.to_i
  end

  def valid_bet(amount)
    amount <= Player.new("Player", session[:player_cards]).bankroll
  end

  def get_player_bet
    session[:player_bet]
  end

  def player_bankroll
    session[:player_bankroll]
  end

  def compare_hands
    pl_cnt = player_count
    dl_cnt = dealer_count
    if pl_cnt > 21
      session[:player_bankroll] -= session[:player_bet]
      "Dealer"
    elsif dl_cnt > 21
      session[:player_bankroll] += 2*session[:player_bet]
      "Player"
    elsif pl_cnt > dl_cnt
      session[:player_bankroll] += 2*session[:player_bet]
      "Player"
    elsif pl_cnt <  dl_cnt
      session[:player_bankroll] -= session[:player_bet]
      "Dealer"
    else
      nil
    end
  end

end