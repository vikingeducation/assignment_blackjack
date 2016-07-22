require 'player'

describe Player do

  let(:player) { Player.new }
  let(:ace_of_spades)  { Ace.new(:spade, :ace) }
  let(:ten_of_spades) { Card.new(:spade, 10) }

  describe '#twenty_one?' do
    it 'returns true if hand values twenty one' do
      player.add_card_to_hand(ace_of_spades)
      player.add_card_to_hand(ten_of_spades)
      expect(player.twenty_one?).to eq(true)
    end

    it 'returns false if hand does not value twenty one' do
      expect(player.twenty_one?).to eq(false)
    end
  end

  describe '#hand_value' do
    it "returns the value of the player's hand" do
      player.add_card_to_hand(ace_of_spades)
      expect(player.hand_value).to eq(11)
    end
  end
end
