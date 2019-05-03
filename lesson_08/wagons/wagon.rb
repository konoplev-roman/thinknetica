# frozen_string_literal: true

module Railway
  class Wagon
    include Manufacturer

    ERROR_CAPACITY = 'Invalid value for capacity change'

    attr_reader :type, :capacity, :used_capacity

    def initialize(capacity)
      @capacity = capacity

      @used_capacity = 0
    end

    def free_capacity
      capacity - used_capacity
    end

    def use_capacity(value)
      raise RailwayError, ERROR_CAPACITY if value > free_capacity

      @used_capacity += value
    end

    def release_capacity(value)
      raise RailwayError, ERROR_CAPACITY if value > used_capacity

      @used_capacity -= value
    end

    def to_s
      "#{self.class}; free: #{free_capacity}; used: #{used_capacity}"
    end
  end
end
