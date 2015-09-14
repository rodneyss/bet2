require_relative '../lib/bet'

describe Bet do
  let(:bet) { Bet.new("W","1",10) }
  
  describe '.new' do
    it 'creates a new Bet object' do
      expect(bet).to_not eq nil
    end
    
    it 'has a bet pick' do
      expect(bet.pick).to eq("1")
    end

    it 'has an amount' do
      expect(bet.amount).to eq(10)
    end

    it 'has a bet type' do
      expect(bet.type).to eq("W")
    end

  end
end
