# frozen_string_literal: true

module Railway
  class CargoWagon < Wagon
    include Validation

    validate :capacity, :type, Numeric

    alias volume capacity
    alias used_volume used_capacity
    alias free_volume free_capacity
    alias take_volume use_capacity
    alias release_volume release_capacity

    def initialize(freight_volume)
      super

      @type = :cargo
    end

    def self.to_s
      'Cargo'
    end
  end
end
