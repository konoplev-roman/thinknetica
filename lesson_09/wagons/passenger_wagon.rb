# frozen_string_literal: true

module Railway
  class PassengerWagon < Wagon
    include Validation

    validate :capacity, :type, Numeric

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

    def use_capacity
      super(1)
    end

    alias take_seat use_capacity

    def release_capacity
      super(1)
    end

    alias release_seat release_capacity
  end
end
