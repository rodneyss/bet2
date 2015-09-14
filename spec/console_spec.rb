require_relative '../lib/console'
require_relative '../lib/race'


describe Console do
  bet_arr = ["BET", "W", "1", 20]
  bet_stringw = "BET:W:1:20"
  bet_stringp = "BET:P:3:20"
  bet_stringe = "BET:E:3,2:22"
  let(:race) { Race.new([*1..8])}
  let(:console) { Console.new(race) }

  
  describe '#valid_bet' do
    it 'returns true for valid win bet' do
      expect( console.send(:valid_bet, bet_stringw) ).to be_truthy
    end

    it 'returns true for valid place bet' do
      expect( console.send(:valid_bet, bet_stringp) ).to be_truthy
    end

    it 'returns true for large amount bet' do
      expect( console.send(:valid_bet, "BET:W:2:5000")).to be_truthy
    end

    it 'returns false when more than 1 horse selected' do
      expect( console.send(:valid_bet, bet_stringe) ).to be_falsey
    end

    it 'returns false when no amount entered' do
      expect( console.send(:valid_bet, "BET:WIN:2:") ).to be_falsey
    end

   
  end


  describe '#valid_exacta' do
    it 'returns true for valid exacta bet' do
      expect( console.send(:valid_exacta, bet_stringe) ).to be_truthy
    end

    it 'returns false when only 1 horse selected' do
      expect( console.send(:valid_exacta, bet_stringw) ).to be_falsey
    end

    it 'returns false when no amount entered' do
      expect( console.send(:valid_exacta, "BET:E:2,4:") ).to be_falsey
    end
  end

  describe '#make_bet' do
    it 'creates a new bet object' do
     expect( console.send(:make_bet, bet_arr) ).to_not eq(nil)
    end
  end

  describe '#get_numbers' do
    it 'returns an array of string numbers from string' do
      expect( console.send(:get_numbers, "RESULT:2:3:1") ).to eq(["2","3","1"])
    end
  end

  describe '#valid_result' do
    it 'returns true for valid results' do
      expect( console.send(:valid_result, "RESULT:2:3:4") ).to be_truthy
    end

    it 'returns false for only 2 numbers' do
      expect( console.send(:valid_result, "RESULT:2:3") ).to be_falsey
    end
  end

  describe '#valid_string?' do
    it 'returns true for a valid win string' do
      expect( console.send(:valid_string?, bet_stringw) ).to eq(true)
    end

    it 'returns true for a valid place string' do
      expect( console.send(:valid_string?, bet_stringp) ).to eq(true)
    end

    it 'returns true for a valid exacta string' do
      expect( console.send(:valid_string?, bet_stringe) ).to eq(true)
    end

    it 'returns true for a valid result string' do
      expect( console.send(:valid_string?, "RESULT:2:1:4") ).to eq(true)
    end

    it 'returns false for invalid string' do
      expect( console.send(:valid_string?, "RESU:2:2:3") ).to eq(false)
    end
  end

  describe '#string_convert' do
    it 'converts string into an array seperated by ":"' do
      expect( console.send(:string_convert, "BET:W:2:30") ).to eq(["BET","W","2","30"])
    end
  end


  describe '#valid_horses?' do
    it 'returns true if horse is valid in win bet win bet' do
      expect( console.send(:valid_horses?, 'BET:W:1:20') ).to eq(true)
    end

    it 'returns true if 2 horses are valid in exacta bet' do
     expect( console.send(:valid_horses?, 'BET:E:1,3:25') ).to eq(true)
   end

    it 'returns false if horseis invalid in a win bet' do
      expect( console.send(:valid_horses?, 'BET:W:10:20') ).to eq(false)
    end

    it 'returns false if 1 valid but 1 horse invalid in exacta bet' do
      expect( console.send(:valid_horses?, 'BET:E:1,10:34') ).to eq(false)
    end

    it 'returns true if horses are valid in result' do
      expect( console.send(:valid_horses?, "RESULT:1:2:4") ).to eq(true)
    end

    it 'returns false if 1 horse is invalid in result' do
      expect( console.send(:valid_horses?, "RESULT:1:2:10") ).to eq(false)
    end
  end
  

  describe '#no_dupe?' do
    it 'returns true if there are no duplicates in array' do
      expect( console.send(:no_dupe?, ["1","2"]) ).to eq(true)
    end

    it 'returns false if there is duplicates in array' do
      expect( console.send(:no_dupe?, ["1","1"]) ).to eq(false)
    end
  end

  describe '#build_string' do
    it 'returns a string' do
      expect( console.send(:build_string, 'W','6' )).to eq("Win:6:$0")
    end
  end

  describe '#update_with_seed' do
    arr = ['Bet:w:2:150', 'Bet:p:2:100', 'Bet:e:2,3:40']

    it 'returns a string with number of bets entered' do
      expect( console.send(:update_with_seed, arr)).to eq('3 bet(s) entered')
    end

    it 'updates a valid win bet' do
      console.send(:update_with_seed, arr)
      expect( race.win_bets.count ).to eq(1)
    end

    it 'updates a valid place bet' do
      console.send(:update_with_seed, arr)
      expect( race.place_bets.count ).to eq(1)
    end

    it 'updates a valid exacta bet' do
      console.send(:update_with_seed, arr)
      expect( race.exacta_bets.count ).to eq(1)
    end
  end

  describe '#get_file_as_string_array' do
    it 'returns an array' do
      expect( console.send(:get_file_as_string_array).class).to eq(Array)
    end

    it 'returns an array that contains elements' do
      expect( console.send(:get_file_as_string_array).empty?).to eq(false)
    end
  end
  
 
end
