# frozen_string_literal: true

module Railway
  class Station
    include Validation
    include InstanceCounter

    # Length of the station name must be greater than 0
    # and not more than 20 characters
    NAME_FORMAT = /^.{1,20}$/.freeze

    attr_reader :name, :trains

    validate :name, :presence
    validate :name, :type, String
    validate :name, :format, NAME_FORMAT

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

    def trains_each
      trains.each.with_index(1) { |train, index| yield(train, index) }
    end

    def trains_each_by(klass)
      trains_by(klass).each.with_index(1) { |train, index| yield(train, index) }
    end
  end
end
