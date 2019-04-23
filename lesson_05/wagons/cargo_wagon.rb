# frozen_string_literal: true

module Railway
  class CargoWagon
    attr_reader :type

    def initialize
      @type = :cargo
    end

    def self.to_s
      'Cargo'
    end
  end
end
