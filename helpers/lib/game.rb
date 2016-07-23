class Game
  def initialize
    @player = HumanPlayer.new
    @dealer = Dealer.new
    @view = GameView.new
    @deck = Deck.new
  end

  # Could switch between players using a @current_player...
  def play
    @player.assign_name
    round_loop
    print_game_results
  end

  private

  def round_loop
    until @player.purse_empty?
      @player.make_bet
      deal
      player_turn
      dealer_turn
      print_round_results
      handle_bet_results
      reset_hands
    end
  end

  def handle_bet_results
    if @player.blackjack?
      @player.handle_blackjack_bet
    elsif player_wins_round?
      @player.handle_winning_bet
    elsif winner == :tie
      @player.regain_bet
    else
      @player.lose_bet
    end
  end

  # This could be moved to the humanplayer class
  def player_turn
    hit_loop(@player)
  end

  # This could be moved to the dealer class...
  def dealer_turn
    @dealer.show_hidden_card
    render_cards(@dealer.cards_in_hand, "The Dealer shows his hidden card...")
    hit_loop(@dealer) unless @player.bust?
  end

  def reset_hands
    @deck.add_card(@player.remove_card_from_hand) until @player.cards_in_hand.empty?
    @deck.add_card(@dealer.remove_card_from_hand) until @dealer.cards_in_hand.empty?
    @deck.shuffle!
  end

  def print_game_results
    @view.print_game_results(@player.purse_amount)
  end

  # This could be moved to the gameview class
  def print_round_results
    @view.print_score_results(@player.hand_value, @dealer.hand_value)
    @view.print_blackjack if @player.blackjack? && player_wins_round?
    if player_wins_round?
      @view.print_player_win
    elsif tie?
      @view.print_tie
    else
      @view.print_player_loss
    end
  end

  def tie?
    winner == :tie
  end

  def player_wins_round?
    winner == @player
  end

  def winner
    return @dealer if @player.bust?
    return @player if @dealer.bust?
    return :tie if @dealer.hand_value == @player.hand_value
    @dealer.hand_value > @player.hand_value ? @dealer : @player
  end

  #This could be moved to the player class
  def hit_loop(competitor)
    until competitor.bust? || competitor.twenty_one?
      sleep 2
      competitor.hit? ? deal_player_cards(competitor, 1) : break
      break if competitor.doubled_down?
      @view.print_busted if competitor.bust?
      @view.print_player_hand(competitor)
    end
    handle_double_down(competitor) if competitor.doubled_down?
  end

  def handle_double_down(competitor)
    deal_player_cards(competitor, 1)
    @view.print_player_hand(competitor)
    sleep 2
    @view.output("About to double bet")
    competitor.double_bet
    competitor.reset_doubled_down
  end

  # This could be moved to the main view class
  def render_cards(cards, message = nil)
    @view.output(message) if message
    @view.render_cards(cards)
  end

  # Perhaps move to a deck view?
  def deal
    @view.print_dealing_message
    deal_player_cards(@player, 2)
    deal_player_cards(@dealer, 2)
    @dealer.make_last_card_facedown
    print_dealt_cards
  end

  def print_dealt_cards
    @view.print_dealt_cards(@player.cards_in_hand, @dealer.cards_in_hand)
  end

  def deal_player_cards(player, num_of_cards)
    cards = get_cards_from_deck(num_of_cards)
    add_cards_to_players_hand(player, cards)
  end

  def add_cards_to_players_hand(player, cards)
    cards.each { |card| player.add_card_to_hand(card) }
  end

  def get_cards_from_deck(num_of_cards)
    cards = []
    num_of_cards.times { cards << @deck.get_card }
    cards
  end
end
