require 'card'

describe Card do

  let(:ten_of_spades)  { Card.new(:spade, 10) }
  let(:king_of_spades) { Card.new(:spade, :king)}

  describe 'a ten of spades' do
    it 'returns its rank' do
      expect(ten_of_spades.rank).to eq(10)
    end

    it 'returns its suit' do
      expect(ten_of_spades.suit).to eq(:spade)
    end

    it 'is showing by default' do
      expect(ten_of_spades.face_up?).to eq(true)
    end
  end

  describe '#flip' do
    it 'flips the card over' do
      ten_of_spades.flip
      expect(ten_of_spades.face_up?).to eq(false)
    end
  end

  describe '#value' do
    it "returns a value matching the card's rank if 10 or under" do
      expect(ten_of_spades.value).to eq(10)
    end

    it 'returns 10 if it is a face card' do
      expect(king_of_spades.value).to eq(10)
    end
  end

  describe '#rank_symbol' do
    it 'returns the value if not a face card' do
      expect(ten_of_spades.rank_symbol).to eq('10')
    end

    it 'returns a capital letter if it is a face card' do
      expect(king_of_spades.rank_symbol).to eq('K')
    end
  end
end
