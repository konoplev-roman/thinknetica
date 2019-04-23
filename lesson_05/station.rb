# frozen_string_literal: true

module Railway
  class Station
    attr_reader :name, :trains

    @stations = []

    def initialize(name)
      @name = name

      @trains = []

      self.class.all << self
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

    def self.all
      @stations
    end
  end
end
