# frozen_string_literal: true

class Station
  attr_reader :trains

  def initialize(name)
    @name = name

    @trains = []
  end

  def take_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by(type)
    @trains.select { |train| train.type == type }
  end
end
