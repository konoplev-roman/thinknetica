# frozen_string_literal: true

module Railway
  class Station
    attr_reader :name, :trains

    def initialize(name)
      @name = name

      @trains = []
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
  end
end
