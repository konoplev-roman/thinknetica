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
        print "\nSelect number: "

        case gets.to_i
        when 0 then break
        when 1 then stations_list
        when 2 then station_create
        when 3 then station_delete
        when 4 then station_trains_list
        when 5 then station_trains_list_by_type
        when 6 then routes_list
        when 7 then route_create
        when 8 then route_delete
        when 9 then route_stations_list
        when 10 then route_station_add
        when 11 then route_station_delete
        when 12 then type_train_list
        when 13 then trains_list
        when 14 then train_create
        when 15 then train_delete
        when 16 then train_route_add
        when 27 then train_go_forward
        when 28 then train_go_back
        when 19 then type_wagon_list
        when 20 then train_wagons_list
        when 21 then train_wagon_add
        when 22 then train_wagon_delete
        when 23 then train_wagon_use_capacity
        when 24 then train_wagon_release_capacity
        else raise RailwayError, 'Invalid command'
        end
      rescue RailwayError => e
        puts e.message
      end
    end

    private

    def print_help
      puts <<~HELP
        List of available commands:

        0 - Exit

        1 - Show station list
        2 - Create station
        3 - Delete the station
        4 - Show train list at the station
        5 - Show train list by type at the station

        6 - Show route list
        7 - Create route
        8 - Delete the route
        9 - Show station list at the route
        10 - Add the station to the route
        11 - Delete the station from the route

        12 - Show types of trains
        13 - Show train list
        14 - Create train
        15 - Delete the train
        16 - Set the train to the route
        17 - To send the train forward
        18 - To send the train back

        19 - Show types of wagons
        20 - Show wagons list at the train
        21 - To attach the wagon to the train
        22 - To detach the wagon to the train
        23 - To use capacity from wagon
        24 - To release capacity from wagon
      HELP
    end

    # --------------------------------------------------------------------------

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

      object = collection[index]

      raise RailwayError, ERROR_SELECT if object.nil?

      object
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
      list(choose(@stations).trains)
    end

    def station_trains_list_by_type
      list(choose(@stations).trains_by(choose(CLASS_TRAINS)))
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
