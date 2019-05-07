# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'manufacturer'
require_relative 'trains/train'
require_relative 'trains/cargo_train'
require_relative 'trains/passenger_train'
require_relative 'wagons/wagon'
require_relative 'wagons/cargo_wagon'
require_relative 'wagons/passenger_wagon'
require_relative 'station'
require_relative 'route'

class RailwayError < StandardError; end

module Railway
  class Cli
    CLASS_TRAINS = [CargoTrain, PassengerTrain].freeze
    CLASS_WAGONS = [CargoWagon, PassengerWagon].freeze

    MENU = [
      { method: :exit, title: 'Exit' },

      { method: :stations_list, title: 'Show station list' },
      { method: :station_create, title: 'Create station' },
      { method: :station_delete, title: 'Delete the station' },
      { method: :station_trains_list, title: 'Show train list at the station' },
      { method: :station_trains_list_by_type, title: 'Show train list by type at the station' },

      { method: :routes_list, title: 'Show route list' },
      { method: :route_create, title: 'Create route' },
      { method: :route_delete, title: 'Delete the route' },
      { method: :route_stations_list, title: 'Show station list at the route' },
      { method: :route_station_add, title: 'Add the station to the route' },
      { method: :route_station_delete, title: 'Delete the station from the route' },

      { method: :type_train_list, title: 'Show types of trains' },
      { method: :trains_list, title: 'Show train list' },
      { method: :train_create, title: 'Create train' },
      { method: :train_delete, title: 'Delete the train' },
      { method: :train_route_add, title: 'Set the train to the route' },
      { method: :train_go_forward, title: 'To send the train forward' },
      { method: :train_go_back, title: 'To send the train back' },

      { method: :type_wagon_list, title: 'Show types of wagons' },
      { method: :train_wagons_list, title: 'Show wagons list at the train' },
      { method: :train_wagon_add, title: 'To attach the wagon to the train' },
      { method: :train_wagon_delete, title: 'To detach the wagon to the train' },
      { method: :train_wagon_use_capacity, title: 'To use capacity from wagon' },
      { method: :train_wagon_release_capacity, title: 'To release capacity from wagon' },

      { method: :print_help, title: 'Print help' }
    ].freeze

    ERROR_COMMAND = 'Invalid command'
    ERROR_NO_ELEMENTS = 'There are no elements'
    ERROR_SELECT = 'The selected number does not exist'

    def initialize
      @stations = []
      @routes = []
      @trains = []
    end

    def start
      print_help

      loop do
        print_separator

        send MENU.fetch(index)[:method]
      rescue IndexError
        puts ERROR_SELECT
      rescue RailwayError => e
        puts e.message
      end
    end

    private

    def print_separator
      puts
    end

    def print_help
      MENU.each.with_index(1) { |m, i| puts "#{i}. #{m[:title]}" }
    end

    def index
      print 'Select number: '

      gets.to_i - 1
    end

    def name
      print 'Enter name: '

      gets.chomp
    end

    def capacity
      print 'Enter capacity: '

      gets.to_i
    end

    def list(collection)
      raise RailwayError, ERROR_NO_ELEMENTS if collection.empty?

      collection.each.with_index(1) { |s, i| puts "#{i}. #{s}" }
    end

    def choose(collection)
      raise RailwayError, 'There are no elements' if collection.empty?

      list(collection)

      collection.fetch(index)
    end

    def stations_list
      list(@stations)
    end

    def station_create
      @stations.push(Station.new(name))
    end

    def station_delete
      @stations.delete(choose(@stations))
    end

    def station_trains_list
      station = choose(@stations)

      station.trains_each do |train, i|
        puts "#{i}. #{train}"

        puts 'Wagons:'

        train.wagons_each { |wagon, j| puts "#{j}. #{wagon}" }
      end
    end

    def station_trains_list_by_type
      station = choose(@stations)
      type = choose(CLASS_TRAINS)

      station.trains_each_by(type) do |train, i|
        puts "#{i}. #{train}"

        puts 'Wagons:'

        train.wagons_each { |wagon, j| puts "#{j}. #{wagon}" }
      end
    end

    def routes_list
      list(@routes)
    end

    def route_create
      puts 'Select start and end station'

      @routes.push(Route.new(choose(@stations), choose(@stations)))
    end

    def route_delete
      @routes.delete(choose(@routes))
    end

    def route_stations_list
      list(choose(@routes).stations)
    end

    def route_station_add
      puts 'Select route and station'

      choose(@routes).add_station(choose(@stations))
    end

    def route_station_delete
      puts 'Select route and station'

      choose(@routes).delete_station(choose(@stations))
    end

    def type_train_list
      list(CLASS_TRAINS)
    end

    def trains_list
      list(@trains)
    end

    def train_create
      @trains.push(choose(CLASS_TRAINS).new(name))
    end

    def train_delete
      @trains.delete(choose(@trains))
    end

    def train_wagon_add
      puts 'Select wagon type and capacity'

      wagon = choose(CLASS_WAGONS).new(capacity)

      choose(@trains).attach_wagon(wagon)
    end

    def train_wagon_delete
      train = choose(@trains)

      train.detach_wagon(choose(train.wagons))
    end

    def train_route_add
      choose(@trains).route = choose(@routes)
    end

    def train_go_forward
      choose(@trains).go_forward
    end

    def train_go_back
      choose(@trains).go_back
    end

    def type_wagon_list
      list(CLASS_WAGONS)
    end

    def train_wagons_list
      list(choose(@trains).wagons)
    end

    def train_wagon_use_capacity
      train = choose(@trains)
      wagon = choose(train.wagons)

      case wagon.type
      when :cargo
        wagon.use_capacity(capacity)
      when :passenger
        wagon.use_capacity
      end
    end

    def train_wagon_release_capacity
      train = choose(@trains)
      wagon = choose(train.wagons)

      case wagon.type
      when :cargo
        wagon.release_capacity(capacity)
      when :passenger
        wagon.release_capacity
      end
    end
  end
end

Railway::Cli.new.start
