module BJ
  def save_game(game)
    session["playerhand"] = game.phand
    session["dealerhand"] = game.dhand
    session["deck"] = game.deck
  end

  def restore_game
    game = Game.new
    game.phand = session["playerhand"]
    game.dhand = session["dealerhand"]
    game.deck = session["deck"]
    game
  end

  def new_hand(player)
    hand = session["deck"].sample(2)
    session["deck"].delete_if {|card| hand.include?(card)}
    session[player+"hand"] = hand
    hand
  end

  def new_deck
    suit = ["Clb", "Dmd", "Hrt", "Spd"]
    number = (1..10).to_a + ["J", "Q", "K"]
    array = number.product(suit)
    session["deck"] = array
    return array
  end

  def hit(player)
    card = session["deck"].sample(1)
    session["deck"].delete(card)
    session[player+"hand"] << card

  end

  def hand_sum(player)
    sum = 0
    session[player+"hand"].each do |card|
    card[0].is_a?(Integer) ? sum += card[0] : sum += 10
    end
    sum
  end
end

class Game
  attr_accessor :deck, :phand, :dhand
  def initialize
    @deck = Deck.new_deck
    @phand = Hand.new(@deck)
    remove(@phand)
    @dhand = Hand.new(@deck)
    remove(@dhand)
  end

  def hit(hand)
    card = @deck.sample(1)[0]
    hand.show << card
    deck.delete(card)
  end


  def remove(hand)

    hand.show.each do |card|
      @deck.delete(card)
    end

  end

end

class Deck
  def self.new_deck
    array = ((1..10).to_a + ["J", "Q", "K"]).product(["Clb", "Dmd", "Hrt", "Spd"])
    array
  end
end

class Hand
  attr_accessor :show
  def initialize(deck)
    @show = deck.sample(2)
  end

  def sum
    sum = 0
    @show.each do |card|
      card[0].is_a?(Integer) ? sum += card[0] : sum += 10
    end
    sum
  end

end
