class Race

  def initialize horses
    @horses      = horses
    @comm        = {'W' => 0.15, 'P' => 0.12, 'E' => 0.18}
    @bets        = {'W'=>{},'P'=>{},'E'=>{}}
    @pool        = {'W' => 0, 'P' => 0, 'E' => 0}
    @results
  end  

  def horses
    @horses
  end

  def win_bets
    @bets['W']
  end

  def place_bets
    @bets['P']
  end

  def exacta_bets
    @bets['E']
  end

  def results
    @results
  end

  #update_bet
  #creates the keys and empty array if the dont exist
  #then pushes bet to correspoding key array
  def update_bet(bet)
    if @bets[bet.type][bet.pick].nil?
      @bets[bet.type][bet.pick] = []
    end

    @bets[bet.type][bet.pick] << bet
  end

  def update_results(result)
    @results = result
  end

  def get_com(type)
    @comm[type]
  end

  def get_pool(type)
    @pool[type]
  end

  def update_pool(type, amount)
    @pool[type] += amount
  end
  
  #calc_return
  #calculate a bet return
  #
  #total == an amount eg 100
  #pool == an amount eg 300
  #commission == a float eg 0.16
  def calc_return(total, pool, commission)
    if pool == 0
      return 0
    elsif total == 0
      return ( pool - (pool*commission) ) 
    else
      return ( pool - (pool*commission) ) / total.to_f
    end
  end

  #get_total
  #gets the total amount for a specific bet type according to number
  #type == "W" or "P" or "E"
  #pick == a string number eg "3"
  #
  #get_total("W", "4")
  #will select all winning bets that have the number "4"
  #sum all the amounts and then return it
  def get_total(type, pick)
    if @bets[type][pick].nil? 
      return 0
    else
      return (@bets[type][pick].map{ |bet| bet.amount}).inject &:+
    end
  end


end
