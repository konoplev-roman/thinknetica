# frozen_string_literal: true

module Railway
  class Train
    attr_reader :number, :speed, :wagons

    def initialize(number)
      @number = number
      @speed = 0

      @wagons = []
      @available_type_wagons = []
    end

    def change_speed_by(value)
      @speed += value

      @speed = 0 if @speed.negative?
    end

    def stop
      @speed = 0
    end

    def attach_wagon(wagon)
      @wagons.push(wagon) if @available_type_wagons.include?(wagon.class) && @speed.zero?
    end

    def detach_wagon(wagon)
      @wagons.delete(wagon) if @speed.zero?
    end

    def route=(route)
      @route = route

      @station_index = 0

      current_station.take_train(self)
    end

    def current_station
      @route.stations[@station_index]
    end

    def next_station
      @route.stations[@station_index + 1]
    end

    def prev_station
      @route.stations[@station_index - 1] if @station_index.positive?
    end

    def go_forward
      return unless next_station

      current_station.send_train(self)
      next_station.take_train(self)

      @station_index += 1
    end

    def go_back
      return unless prev_station

      current_station.send_train(self)
      prev_station.take_train(self)

      @station_index -= 1
    end
  end
end
