# frozen_string_literal: true

module Railway
  class PassengerWagon < Wagon
    alias seats capacity
    alias used_seats used_capacity
    alias free_seats free_capacity

    def initialize(seats)
      super

      @type = :passenger
    end

    def self.to_s
      'Passenger'
    end

    def take_seat
      use_capacity(1)
    end

    def release_seat
      release_capacity(1)
    end
  end
end
