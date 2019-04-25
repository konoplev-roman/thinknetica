# frozen_string_literal: true

module Railway
  class Wagon
    include Manufacturer

    attr_reader :type
  end
end
