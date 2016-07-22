require 'player'
require 'dealer'
describe Dealer do

  let(:dealer) { Dealer.new }
  let(:king_of_spades)  { Card.new(:spade, :king) }
  let(:seven_of_spades) { Card.new(:spade, 7) }

  describe '#make_last_card_facedown' do
    it 'flips the last card' do
      dealer.add_card_to_hand(king_of_spades)
      dealer.make_last_card_facedown
      expect(dealer.last_card_in_hand.face_up?).to eq(false)
    end
  end

  describe '#hit?' do
    it 'returns true if hand value is less than 17' do
      dealer.add_card_to_hand(king_of_spades)
      expect(dealer.hit?).to eq(true)
    end

    it 'returns false if hand value is 17 or greater' do
      dealer.add_card_to_hand(king_of_spades)
      dealer.add_card_to_hand(seven_of_spades)
      expect(dealer.hit?).to eq(false)
    end
  end
end
