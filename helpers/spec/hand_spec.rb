require 'hand'
require 'ace'

describe Hand do

  let(:hand) { Hand.new }
  let(:king_of_spades) { Card.new(:spade, :king) }
  let(:ace_of_spades)  { Ace.new(:spade, :ace)   }
  let(:ace_of_hearts)  { Ace.new(:heart, :ace)   }

  describe '#add_card' do
    it 'adds a card' do
      hand.add_card(king_of_spades)
      expect(hand.num_of_cards).to eq(1)
    end
  end

  describe '#bust?' do
    it 'returns false for a hand totalling less than 21' do
      hand.add_card(king_of_spades)
      expect(hand.bust?).to eq(false)
    end

    it 'returns true for a hand totalling greater than 21' do
      3.times { hand.add_card(king_of_spades) }
      expect(hand.bust?).to eq(true)
    end

    it 'returns false if aces can be toggled' do
      hand.add_card(ace_of_spades)
      hand.add_card(ace_of_hearts)
      expect(hand.bust?).to eq(false)
    end
  end

  describe '#total_value' do

    it 'returns 0 if there are no cards' do
      expect(hand.total_value).to eq(0)
    end

    it 'toggles the min number of aces required to be less than 21' do
      hand.add_card(ace_of_spades)
      hand.add_card(ace_of_hearts)
      expect(hand.total_value).to eq(12)
    end
  end
end
