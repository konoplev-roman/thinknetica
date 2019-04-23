# frozen_string_literal: true

module Railway
  class PassengerWagon
    attr_reader :type

    def initialize
      @type = :passenger
    end

    def self.to_s
      'Passenger'
    end
  end
end
