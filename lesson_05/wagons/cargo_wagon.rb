# frozen_string_literal: true

module Railway
  class CargoWagon < Wagon
    def initialize
      @type = :cargo
    end

    def self.to_s
      'Cargo'
    end
  end
end
