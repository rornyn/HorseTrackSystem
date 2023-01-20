class Horse
  attr_accessor :payout :amount
  def initialize(id, payout, amount)
    @id = id
    @payout = payout
    @dispencing_payout = amount
  end
end