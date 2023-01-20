class HorseBet
  attr_accessor :hourses
  def initialize
    @hourses = Hash.new(0)
  end
  
  def create_bet(horse_id, amount, inventory_obj)
    horse = HorseTrackData::HourseList[horse_id]
    old_amount = @hourses[horse_id]
    bet_amount = horse[:odd] * amount
    payout = inventory_obj.process_bet_transaction(bet_amount)
    hourses[horse_id] = Horse.new(horse[:name], payout, bet_amount)
  end
end