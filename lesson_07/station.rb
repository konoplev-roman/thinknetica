# frozen_string_literal: true

module Railway
  class Station
    include InstanceCounter

    ERROR_NAME = 'Length of the station name must be greater than 0' \
                 'and not more than 20 characters'

    attr_reader :name, :trains

    @stations = []

    def initialize(name)
      @name = name

      @trains = []

      validate!

      self.class.all << self

      register_instance
    end

    def self.all
      @stations
    end

    def take_train(train)
      @trains.push(train)
    end

    def send_train(train)
      @trains.delete(train)
    end

    def trains_by(klass)
      @trains.select { |train| train.class == klass }
    end

    def to_s
      name
    end

    def valid?
      validate!

      true
    rescue RailwayError
      false
    end

    def trains_each
      trains.each.with_index(1) { |train, index| yield(train, index) }
    end

    def trains_each_by(klass)
      trains_by(klass).each.with_index(1) { |train, index| yield(train, index) }
    end

    private

    def validate!
      raise RailwayError, ERROR_NAME unless name.length.between?(1, 20)
    end
  end
end
