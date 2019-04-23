# frozen_string_literal: true

module Railway
  class Route
    def initialize(start_station, end_station)
      @start_station = start_station
      @end_station = end_station

      @intermediate_stations = []
    end

    def add_station(station)
      @intermediate_stations.push(station)
    end

    def delete_station(station)
      @intermediate_stations.delete(station)
    end

    def stations
      [@start_station, *@intermediate_stations, @end_station]
    end

    def to_s
      "from #{stations.first} to #{stations.last}"
    end
  end
end
