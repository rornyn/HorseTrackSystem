class InvalidHorse < StandardError; end
class InsufficientAmount < StandardError; end
class InvalidInput < StandardError; end

class HorseTrackSystem
  attr_reader :inventory, :horse_bet

    def initialize
      @inventory = Inventory.new
      @horse_bet = HorseBet.new
    end

    def run
      print_default_data
      take_user_input
    end

    private

    def print_default_data
      print_inventory_data
      print_horse_data
      input_instruction
    end

    def print_inventory_data
      puts "Inventory"
      puts "___________________________________________"
      inventory.data.each do |k,v|
        puts "$#{k}, #{v}"
      end
    end

    def print_horse_data
      horse = last_race_result
      puts "Horse:"
      puts "___________________________________________"
      HorseTrackData::HourseList.each do |hourse_no, data|
        result = hourse_no.to_i == horse.to_i ? "Win" : "Loss"
        puts "#{hourse_no}, #{data[:name]}, #{data[:odd]}, #{result} "
      end
      print "___________________________________________"
    end

    def last_race_result
      file = File.open(HorseTrackData::FileName, "r")
      wining_hourse = file.readlines.map(&:chomp).first
      file.close()
      wining_hourse
    end

    def take_user_input
      input_data = gets.chomp.split
      quit_application if input_for_quit_application(input_data)  
      if input_for_restock?(input_data)
        process_restock_cash
      elsif input_for_winning_horse?(input_data)
        set_winning_horse(input_data)
      elsif input_for_winning_horse?(input_data)
        process_horse_data(input_data)
      else
      
      end
    end

    def process_horse_data(horse_data)
      horse_data = horse_data.map(&:to_i)
      validate_horse_data(horse_data)
      horse = horse_bet.create_bet(horse_data.first, horse_data.last)
      show_payout_horse(horse)
    end

    def input_instruction
      puts "___________________________________________"
      puts"Enter 'R' or 'r' - restocks the cash inventory"
      puts "Enter 'Q' or 'q' - quits the application"
      puts "Enter 'W' or 'w' [1-7] - sets the winning horse number"
      puts "Enter Horse no. [1-7] <amount> - specifies the horse wagered on and the amount of the bet For ex. '1 55'"
      puts "___________________________________________"
    end

    def validate_horse_data(horse_data)
      raise InvalidInput.new "Invalid Input" if invalid_input?(horse_data)
      raise InvalidHorse.new("Enter Valid Horse no.") if invalid_horse?(horse_data.first)
      raise InsufficientAmount.new("Insufficient amount") if insufficient_amount?(horse_data.last)
    rescue InvalidInput, InvalidHorse, InsufficientAmount => e
      puts e.message
      puts "Try Again .."
      take_user_input
    end

    def invalid_horse?(horse)
     !HorseTrackData::HourseList.keys.include?(horse)
    end

    def insufficient_amount?(amount)
      inventory.available_amount < amount 
    end

    def invalid_input?(horse_data)
      (horse_data.count != 2) || horse_data.last.nil? || (horse_data.last <= 0) 
    end

    def process_restock_cash
      @inventory = Inventory.new
    end

    def quit_application
      exit
    end

    def input_for_quit_application(input_data)
      (input_data.length == 1) && HorseTrackData::QuitApplication.include?(input_data.first)
    end

    def input_for_restock?(input_data)
      (input_data.length == 1) && HorseTrackData::RestockCash.include?(input_data.first)
    end

    def input_for_winning_horse?(horse_data)
      horse_data.length == 2 && HorseTrackData::Winning.include?(horse_data.first) && HorseTrackData::HourseList.keys.include?(horse_data.last.to_i)
    end

    def set_winning_horse(input_data)
      File.write(HorseTrackData::FileName, input_data[1])
    end

    def show_payout_horse(horse)

    end

end