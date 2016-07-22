require 'card'
require 'ace'

describe Ace do

  let(:ace_of_spades)  { Ace.new(:spade, :ace)}

  describe '#toggle_value' do
    it "toggles an ace's value"  do
      ace_of_spades.toggle_value
      expect(ace_of_spades.value).to eq(1)
    end
  end

  describe '#rank_symbol' do
    it 'works for aces' do
      expect(ace_of_spades.rank_symbol).to eq('A')
    end
  end
end
