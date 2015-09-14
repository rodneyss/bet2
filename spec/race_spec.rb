require_relative '../lib/race'
require_relative '../lib/bet'

describe Race do
  horses = [1,2,3,4,5,6,7,8]
  let(:race) { Race.new(horses) }
 

  describe '.new' do
    it 'creates a new object' do
      expect(race).to_not eq nil
    end

    it 'has horses' do
      expect(race.horses).to eq(horses)
    end

    it 'has no win bets' do
      expect(race.win_bets).to eq({})
    end

    it 'has no place bets' do
      expect(race.place_bets).to eq({})
    end

    it 'has no exacta bets' do
      expect(race.exacta_bets).to eq({})
    end
  end
  
  describe '#update_bet' do
    let(:bet)  { Bet.new("W","3",10) }
    let(:bet2) { Bet.new("W","3",30) }
    let(:bet3) { Bet.new("W","7",22) }
    let(:bet4p) { Bet.new("P","7",12) }
    let(:bet5e) { Bet.new("E","7,9",15) }

    it 'pushes a win bet into win_bets' do
      race.update_bet(bet)
      expect(race.win_bets).to eq( {"3"=>[bet]} )
    end

    it 'pushes a place bet into place_bets' do
      race.update_bet(bet4p)
      expect(race.place_bets).to eq( {"7"=>[bet4p]})
    end

    it 'pushes an exacta bet into exacta_bets' do
      race.update_bet(bet5e)
      expect(race.exacta_bets).to eq( {"7,9"=>[bet5e]} )
    end

    it 'pushes similar win bets into same key' do
      race.update_bet(bet)
      race.update_bet(bet2)
      expect(race.win_bets).to eq( {"3"=>[bet,bet2]} )
    end

    it 'pushes multiple bets to seperate keys'do
      race.update_bet(bet)
      race.update_bet(bet2)
      race.update_bet(bet3)
      expect(race.win_bets).to eq( {"3"=>[bet,bet2], "7"=>[bet3]} )
    end

  end

  describe "#update_results" do
    it 'updates results variable' do
      race.update_results([1,2,3])
      expect(race.results).to eq([1,2,3])
    end
  end
 
  describe '#get_com' do
    it 'returns commissions rate of win pool' do
      expect(race.get_com('W')).to eq(0.15)
    end

    it 'returns commission rate of place pool' do
      expect(race.get_com('P')).to eq(0.12)
    end

    it 'returns commission rate of exacta pool' do
      expect(race.get_com('E')).to eq(0.18) 
    end
  end

  describe '#get_pool' do
    it 'returns win pool' do
      expect(race.get_pool('W')).to eq(0)
    end
    
    it 'returns place pool' do
      expect(race.get_pool('P')).to eq(0)
    end

    it 'returns exacta pool' do
      expect(race.get_pool('E')).to eq(0)
    end
  end

  describe '#update_pool' do
    it 'updates win pool with cumulative total' do
      race.update_pool('W', 10)
      race.update_pool('W', 39)
      expect(race.get_pool('W')).to eq(49)
    end
    
    it 'updates place pool with cumulative total' do
      race.update_pool('P', 11)
      race.update_pool('P', 12)
      expect(race.get_pool('P')).to eq(23)
    end

    it 'updates exacta pool with cumulative total' do
      race.update_pool('E', 11)
      race.update_pool('E', 16)
      expect(race.get_pool('E')).to eq(27)
    end
  end

  describe '#calc_return' do
    it 'returns dividend from pool' do
      expect(race.calc_return(20, 200, 0.1)).to eq(9)
    end

    it 'returns 0 when pool is 0' do
      expect(race.calc_return(0, 0, 0.18)).to eq(0)
    end

    it 'returns dividend when no winners' do
      expect(race.calc_return(0, 200, 0.1)).to eq(180)
    end

  end

  describe '#get_total' do
    let(:bet)  { Bet.new("W","3",10) }
    let(:bet2) { Bet.new("W","3",30) }
    
    it 'returns cumulative amount for matching win bet selection' do
      race.update_bet(bet)
      race.update_bet(bet2)
      expect(race.get_total("W","3")).to eq(40)
    end

    it 'returns 0 if there are no bets matching' do
      race.update_bet(bet)
      race.update_bet(bet2)
      expect(race.get_total("W","1")).to eq(0)
    end
  end


end



