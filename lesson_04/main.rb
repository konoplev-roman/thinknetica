# frozen_string_literal: true

require_relative 'trains/train'
require_relative 'trains/cargo_train'
require_relative 'trains/passenger_train'
require_relative 'wagons/cargo_wagon'
require_relative 'wagons/passenger_wagon'
require_relative 'station'
require_relative 'route'

class CliError < StandardError; end

module Railway
  class Cli
    CLASS_TRAINS = [CargoTrain, PassengerTrain].freeze
    CLASS_WAGONS = [CargoWagon, PassengerWagon].freeze

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
        when 13 then type_wagon_list
        when 14 then trains_list
        when 15 then train_create
        when 16 then train_delete
        when 17 then train_wagon_add
        when 18 then train_wagon_delete
        when 19 then train_route_add
        when 20 then train_go_forward
        when 21 then train_go_back
        else raise CliError, 'Invalid command'
        end
      rescue CliError => e
        puts e.message
      end
    end

    # --------------------------------------------------------------------------

    def stations_list
      puts 'Available stations:'

      @stations.each.with_index(1) { |s, i| puts "#{i}. #{s.name}" }
    end

    def station_create
      @stations.push(Station.new(name))
    end

    def station_delete
      @stations.delete(select_station)
    end

    def station_trains_list
      puts 'Available trains at the stations'

      select_station.trains.each.with_index(1) do |t, i|
        puts "#{i}. #{t.class} #{t.number}"
      end
    end

    def station_trains_list_by_type
      puts 'Available trains by type at the station'

      select_station.trains_by(select_class_train).each.with_index(1) do |t, i|
        puts "#{i}. #{t.class} #{t.number}"
      end
    end

    # --------------------------------------------------------------------------

    def routes_list
      puts 'Available routes:'

      @routes.each.with_index(1) do |r, i|
        puts "#{i}. from #{r.stations.first.name} to #{r.stations.last.name}"
      end
    end

    def route_create
      puts 'Select start and end station'

      @routes.push(Route.new(select_station, select_station))
    end

    def route_delete
      @routes.delete(select_route)
    end

    def route_stations_list
      select_route.stations.each.with_index(1) { |s, i| puts "#{i}. #{s.name}" }
    end

    def route_station_add
      puts 'Select route and station'

      select_route.add_station(select_station)
    end

    def route_station_delete
      puts 'Select route and station'

      select_route.delete_station(select_station)
    end

    # --------------------------------------------------------------------------

    def type_train_list
      puts 'Available types of trains:'

      CLASS_TRAINS.each.with_index(1) { |c, i| puts "#{i}. #{c}" }
    end

    def type_wagon_list
      puts 'Available types of wagons:'

      CLASS_WAGONS.each.with_index(1) { |c, i| puts "#{i}. #{c}" }
    end

    def trains_list
      puts 'Available trains:'

      @trains.each.with_index(1) { |t, i| puts "#{i}. #{t.class} #{t.number}" }
    end

    def train_create
      @trains.push(select_class_train.new(name))
    end

    def train_delete
      @trains.delete(select_train)
    end

    def train_wagon_add
      select_train.attach_wagon(select_class_wagon.new)
    end

    def train_wagon_delete
      train = select_train

      train.detach_wagon(train.wagons.last)
    end

    def train_route_add
      select_train.route = select_route
    end

    def train_go_forward
      select_train.go_forward
    end

    def train_go_back
      select_train.go_back
    end

    # --------------------------------------------------------------------------

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
        13 - Show types of wagons
        14 - Show train list
        15 - Create train
        16 - Delete the train
        17 - To attach the wagon to the train
        18 - To detach the wagon to the train
        19 - Set the train to the route
        20 - To send the train forward
        21 - To send the train back
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

    # --------------------------------------------------------------------------

    def select_station
      raise CliError, 'There are no stations' if @stations.empty?

      stations_list

      station = @stations[index]

      raise CliError, 'The selected number does not exist' if station.nil?

      station
    end

    def select_route
      raise CliError, 'There are no routes' if @routes.empty?

      routes_list

      route = @routes[index]

      raise CliError, 'The selected number does not exist' if route.nil?

      route
    end

    def select_train
      raise CliError, 'There are no trains' if @trains.empty?

      trains_list

      train = @trains[index]

      raise CliError, 'The selected number does not exist' if train.nil?

      train
    end

    def select_class_train
      raise CliError, 'No train types available' if CLASS_TRAINS.empty?

      type_train_list

      klass = CLASS_TRAINS[index]

      raise CliError, 'The selected number does not exist' if klass.nil?

      klass
    end

    def select_class_wagon
      raise CliError, 'No wagon types available' if CLASS_WAGONS.empty?

      type_wagon_list

      klass = CLASS_WAGONS[index]

      raise CliError, 'The selected number does not exist' if klass.nil?

      klass
    end
  end
end

Railway::Cli.new.start
