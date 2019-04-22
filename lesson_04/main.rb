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
        print "\n> "

        command = gets.chomp.downcase.split(/\s/)

        case command.shift
        when 'exit'
          exit
        when 'help'
          print_help
        when 'stations'
          command_with_stations(command)
        when 'routes'
          command_with_routes(command)
        when 'trains'
          command_with_trains(command)
        else
          raise CliError, 'Invalid command'
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

        stations list \t\t - Show station list
        stations create \t - Create station
        stations delete \t - Delete the station
        stations trains \t - Show train list at the station
        stations trains_by \t - Show train list by type at the station

        routes list \t\t - Show route list
        routes create \t\t - Create route
        routes delete \t\t - Delete the route
        routes stations \t - Show station list at the route
        routes station_add \t - Add the station to the route
        routes station_delete \t - Delete the station from the route

        trains type \t\t - Show types of trains
        trains wagon_type \t - Show types of wagons
        trains list \t\t - Show train list
        trains create \t\t - Create train
        trains delete \t\t - Delete the train
        trains wagon_add \t - To attach the wagon to the train
        trains wagon_delete \t - To detach the wagon to the train
        trains route_add \t - Set the train to the route
        trains go_forward \t - To send the train forward
        trains go_back \t\t - To send the train back

        help \t\t\t - Print command list
        exit \t\t\t - Exit
      HELP
    end

    def command_with_stations(command)
      case command.shift
      when 'list'
        stations_list
      when 'create'
        station_create
      when 'delete'
        station_delete
      when 'trains'
        station_trains_list
      when 'trains_by'
        station_trains_list_by_type
      else
        raise CliError, 'Invalid command'
      end
    end

    def command_with_routes(command)
      case command.shift
      when 'list'
        routes_list
      when 'create'
        route_create
      when 'delete'
        route_delete
      when 'stations'
        route_stations_list
      when 'station_add'
        route_station_add
      when 'station_delete'
        route_station_delete
      else
        raise CliError, 'Invalid command'
      end
    end

    def command_with_trains(command)
      case command.shift
      when 'type'
        type_train_list
      when 'wagon_type'
        type_wagon_list
      when 'list'
        trains_list
      when 'create'
        train_create
      when 'delete'
        train_delete
      when 'wagon_add'
        train_wagon_add
      when 'wagon_delete'
        train_wagon_delete
      when 'route_add'
        train_route_add
      when 'go_forward'
        train_go_forward
      when 'go_back'
        train_go_back
      else
        raise CliError, 'Invalid command'
      end
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
