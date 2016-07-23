class Deck
  def initialize
    @cards = new_deck.shuffle
  end

  def shuffle!
    @cards.shuffle!
  end

  def size
    @cards.size
  end

  def add_card(card)
    @cards << card
  end

  def get_card
    empty? ? (raise DeckEmptyError) : @cards.pop
  end

  private

  def empty?
    @cards.empty?
  end

  def ranks
    (2..10).to_a << :ace << :jack << :queen << :king
  end

  def suits
    [:spade, :heart, :diamond, :club]
  end

  def new_deck
    return_array = []
    ranks.each do |rank|
      suits.each do |suit|
        if rank == :ace
          return_array << Ace.new(suit, rank)
        else
          return_array << Card.new(suit, rank)
        end
      end
    end
    return_array
  end
end
