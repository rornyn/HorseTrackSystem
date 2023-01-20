class Inventory
  DefaultAmount = 10
  Currency = [100, 20, 10, 5, 1]
  attr_accessor :data, :available_amount
  def initialize
    @data = {}
    Currency.map{|e| @data[e] = DefaultAmount}
    @available_amount = Currency.inject(0) {|sum, number| sum + number * DefaultAmount}
  end

  def process_bet_transaction(amount)
    currency_counter = Hash.new(0)
    Currency.each do |currency|
      currency_counter[currency] += 0
      if amount >= currency
        currency_counter[currency] += amount / currency
        amount = amount % currency
      end
    end
    update_inventory_data(currency_counter)
    currency_counter
  end

  def update_inventory_data(currency_counter)
    currency_counter.each do |k, v|
      available_count = @data[k]
      available_count -= v
      raise InsufficientAmount.new("Insufficient $#{k} count")  available_count.negative?
    end
  end
end