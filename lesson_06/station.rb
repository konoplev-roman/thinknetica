# frozen_string_literal: true

module Railway
  class Station
    include InstanceCounter

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

    private

    def validate!
      raise RailwayError, 'Length of the station name must be greater than 0 and not more than 20 characters' unless name.length.between?(1, 20)
    end
  end
end
