module GameHelper

  def save_game_state(player, hand = nil)
    session[:player] = player
    session[:hand] = hand
  end


  def declare_winner(player_total, dealer_total)
    winner = ""

    winner = "Dealer wins!" if busted?(player_total)
    winner = "Player wins!" if busted?(dealer_total)

    if winner == ""
      winner = case player_total <=> dealer_total
      when -1
        "Dealer wins!"
      when 1
        "Player wins!"
      when 0
        "Push!"
      end
    end

    winner

  end


  def busted?(total)
    total > 21
  end




=begin
  def build_new_deck
    deck = ( (2..10).to_a + ["J","Q","K","A"] )*4
    deck.shuffle!
  end


  def calculate(hand)
    values = get_card_values(hand)

    number_of_aces = hand.count("A")

    total = values.inject { |sum, card| sum += card }

    reduce_aces(total, number_of_aces)
  end


  def get_card_values(hand)
    # drop total @ index=0
    values = hand[1..-1]

    values.map! do |card|
      if %w[J Q K].include?(card)
        10
      elsif card == "A"
        11 # all Aces start as 11
      else
        card
      end
    end

    values
  end
=end

=begin
  def reduce_aces(total, ace_count)
    aces_at_11 = ace_count

    until total <= 21 || aces_at_11 < 1
      total -= 10
      aces_at_11 -= 1
    end

    total
  end
=end

end
