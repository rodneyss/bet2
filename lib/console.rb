require_relative 'bet'

class Console

  def initialize race
    @race = race
  end

  def ask_input
    #if arr is a bet the array layout will be
    #arr == ["TYPE", "bet type", "pick", "amount"]
    #eg. ["BET", "E", "1,2", "45"] or ["BET", "W", "4", "20"]

    #if arr is a result the array layout will be
    #arr == ["TYPE", "first place", "second place", "third place"]
    #eg. ["RESULT", "2", "4", "5"]
    accepting_input do |arr|
      if arr[0] == 'RESULT'
        #arr.drop(1) returns array excluding first element
        #dont need word "RESULT"
        @race.update_results( arr.drop(1) )
        output_dividends
      else
        bet = make_bet( arr )
        update_bet(bet)
      end
    end
  end


  private

  def output_dividends
    first  = @race.results[0]
    second = @race.results[1]
    third  = @race.results[2]
    exacta = @race.results.take(2).join(",")

    puts build_string('W', first)
    puts build_string('P', first)
    puts build_string('P', second)
    puts build_string('P', third)
    puts build_string('E', exacta)
  end

  def build_string(type, horse)
    bet = {'W' => 'Win', 'P' => 'Place', 'E' => 'Exacta'}

    #pool = type == 'P' ? @race.get_pool(type)/3 : @race.get_pool(type)

    total = @race.calc_return( @race.get_total(type, horse),
                               @race.get_pool(type),
                               @race.get_com(type)
                             )

    total = total / 3 if type == "P"
    total = total.round(2) unless total == 0

    return "#{bet[type]}:#{horse}:$#{total}"
  end

  #update_bet
  #
  #pushes bet object to bet array
  #updates pool total for bet type
  def update_bet(bet)
    @race.update_bet( bet )
    @race.update_pool( bet.type, bet.amount )
  end

  def valid_horses?(str)
    horses = []
    
    #if str is a result string- get array of numbers
    #and convert to integers
    #else str is a bet string- get array of numbers but drop the
    #last element because its the bet amount, then convert
    #to integers
    if valid_result(str)
      horses = get_numbers(str).map(&:to_i)
    else 
      horses = get_numbers(str)[0...-1].map(&:to_i)
    end
    
    #compare arrays for valid horses
    horses == horses & @race.horses
  end

  def no_dupe?(arr)
    arr == arr.uniq
  end
 
  #takes in an array with the format
  #["command", "bet type", 'horse pick', 'amount']
  #eg. ["BET","W","3","200"]
  #returns new bet object
  def make_bet arr
    bet = Bet.new(arr[1], arr[2], arr[3].to_i)
  end

  #returns an array of string numbers
  #eg ["1","2","5"]
  def get_numbers(str)
    str.scan(/\d+/)
  end

  def valid_bet(str)
    str =~ /^BET:[WP]:\d+:[1-9]\d*$/
  end

  def valid_exacta(str)
    str =~ /^BET:E:\d+,\d+:[1-9]\d*$/
  end

  def valid_result(str)
    str =~ /^RESULT:\d+:\d+:\d+/
  end

  def valid_string?(str)
    !!valid = valid_bet(str) || valid_exacta(str) || valid_result(str)
  end

  def string_convert(string)
    string.split(":")
  end

  def get_input
    gets.chomp.upcase
  end

  def accepting_input
    print "enter input: "
    str =  get_input
    
    if str =~ /^SEED/
      puts update_with_seed(get_file_as_string_array)
      return
    end
    
    unless valid_string?(str)
      puts "invalid input"
      return
    end
    
    unless valid_horses?(str)
      puts "invalid bet"
      return
    end

    yield( string_convert(str) )
  end

  #get_file_as_string_array
  #reads a file that has strings in bet format
  #returns an array of strings
  #
  #returns  ['Bet:w:2:150', 'Bet:p:2:100', 'Bet:e:2,3:40']
  def get_file_as_string_array
    file = ("#{File.dirname(__FILE__)}/../data/seed.txt")
    string_array = []
  
    File.open(file, 'r') do |f|
      f.each_line do |line|
        string_array << line
      end
    end
   
    string_array
  end

  #update_with_seed
  #updates bets with an array of bets
  #returns how many bets were entered
  def update_with_seed(arr)
    count = 0

    arr.each do |bet|
      str = bet.chomp.strip.upcase
     
      if valid_string?(str) && valid_horses?(str)
       update_bet( make_bet(  string_convert(str) ) )
       count += 1
      end
    end
   
    return "#{count} bet(s) entered"
  end
end
