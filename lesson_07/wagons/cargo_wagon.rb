# frozen_string_literal: true

module Railway
  class CargoWagon < Wagon
    alias volume capacity
    alias used_volume used_capacity
    alias free_volume free_capacity

    def initialize(freight_volume)
      super

      @type = :cargo
    end

    def self.to_s
      'Cargo'
    end

    def take_volume(value)
      use_capacity(value)
    end

    def release_volume(value)
      release_capacity(value)
    end
  end
end
