# frozen_string_literal: true

module Railway
  class PassengerWagon < Wagon
    def initialize
      @type = :passenger
    end

    def self.to_s
      'Passenger'
    end
  end
end
