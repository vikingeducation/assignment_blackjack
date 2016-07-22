require './dealer'
require './deck'

describe Dealer do 


  let(:dealer) {Dealer.new}

    describe '#hand_value' do 
      
      specify "value of the hand is calculated correctly given two cards" do 
        
        expect(dealer.hand_value([[7, "C"], [6, "H"]])).to eq(13)
      end

      specify "value of the hand is calculated correctly given only aces" do 
        
        expect(dealer.hand_value([[13, "C"], [13, "H"]])).to eq(2)
      end

      specify "value of the hand is calculated correctly given a soft 17" do 
        
        expect(dealer.hand_value([[13, "C"], [6, "H"]])).to eq(7)
      end

      specify "value of the hand is calculated correctly given a different soft 17" do 
        
        expect(dealer.hand_value([[13, "C"], [13, "H"], [5, "C"]])).to eq(7)
      end
    end
  end