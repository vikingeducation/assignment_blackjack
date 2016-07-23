require 'deck_empty_error'
require 'deck'

describe Deck do

  let(:deck) { Deck.new }
  let(:card) { Card.new(:spade, :king) }

  describe '#size' do
    it 'returns 52' do
      expect(deck.size).to eq(52)
    end
  end

  describe '#get_card' do
    it 'returns a card' do
      expect(deck.get_card).to be_an_instance_of(Card)
    end

    it 'raises an exception if deck is empty' do
      52.times { deck.get_card}
      expect { deck.get_card }.to raise_error(DeckEmptyError)
    end
  end

  describe '#add_card' do
    it 'adds a card to the deck' do
      deck.add_card(card)
      expect(deck.size).to eq(53)
    end
  end
end


