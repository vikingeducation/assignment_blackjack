class CardDeck
  attr_reader :deck
  def initialize(current = [])
    @deck = current.empty? ? create_deck : current
  end

  def empty_deck?
    true if @deck.empty?
  end

  def take_card(player)
    player.hand << @deck.pop
    player.hand_sum
  end

  private
  def create_deck
    card_faces = [*1..13]
    card_suits = %w(Spade Heart Club Diamond)
    deck = card_suits.map do |suit|
      card_faces.map do |face|
        [face,suit]
      end
    end
    deck.flatten!(1).shuffle!
  end
end