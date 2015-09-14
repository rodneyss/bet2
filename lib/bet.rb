class Bet
  
  def initialize(type, pick, amount)
    @pick = pick
    @amount = amount
    @type = type
  end

  def pick
    @pick
  end

  def amount
    @amount
  end

  def type
    @type
  end

end
