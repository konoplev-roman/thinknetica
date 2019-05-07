# frozen_string_literal: true

module Railway
  class CargoTrain < Train
    include Validation

    validate :number, :presence
    validate :number, :type, String
    validate :number, :format, NUMBER_FORMAT

    def initialize(number)
      super

      @available_type_wagons = %i[cargo]
    end

    def self.to_s
      'Cargo'
    end
  end
end
