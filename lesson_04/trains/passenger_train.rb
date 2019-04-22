# frozen_string_literal: true

module Railway
  class PassengerTrain < Train
    def initialize(number)
      super

      @available_type_wagons = [PassengerWagon]
    end

    def self.to_s
      'Passenger'
    end
  end
end
