require_relative 'championship'

class Program
  @@exit = false
  @@championship_started = false

  class << self
    def add_team
      puts 'Nuevo equipo'
      team_name = get_input('Ingresa el nombre del equipo:')

      @@championship.add_team(team_name)
    end

    def add_player
      puts 'Nuevo jugador'
      team_name = get_input('Ingresa el nombre del equipo:')
      ci = get_input('Ingresa la cedula del jugador:')
      full_name =  get_input('Ingresa el nombre completo del jugador:')
      age = get_input('Ingresa la edad del jugador:')

      @@championship.add_player(team_name, ci, full_name, age)
    end

    def list_teams
      @@championship.print_teams
    end

    def list_players
      team_name = get_input('Ingresa el nombre del equipo:')
      @@championship.print_players(team_name)
    end

    def start_championship
      can_start = @@championship.generate_fixture
      if can_start
        @@championship.print_fixture
        @@championship_started = true
      end
    end

    def display_fixture
      @@championship.print_fixture
    end

    def next_match
      match = @@championship.next_match
      if match
        score_team_a = get_input('Ingresa los goles del primer equipo:')
        score_team_b = get_input('Ingresa los goles del segundo equipo:')
        @@championship.set_match_result(match, score_team_a, score_team_b)
      end
    end

    def display_table
      @@championship.print_table
    end

    def exit
      @@exit = true
    end

    def display_menu(options)
      puts @@championship.summary
      puts 'Ingresa el nro de la opcion deseada:'

      options.each do |option, option_data|
        puts "#{option}. #{option_data[:text]}"
      end
    end

    def handle_user_input(options, args)
      print '> '
      option = $stdin.gets.chomp

      if options.has_key?(option)
        send(options[option][:method], *args)
        option
      else
        puts 'Opcion inválida. Ingrese otra.'
      end
    end

    def get_input(description)
      puts description
      print '> '
      $stdin.gets.chomp
    end

    def run
      puts 'Bienvenido!'
      championship_name = get_input('Ingresa el nombre de tu campeonato:')
      championship_players_count = get_input('Ingresa de cuantos jugadores seran los equipos:')

      @@championship = Championship.new(championship_name, championship_players_count)

      while !@@exit && !@@championship_started
        options = {
          '1' => { text: 'Agregar equipo', method: :add_team },
          '2' => { text: 'Listar equipos', method: :list_teams },
          '3' => { text: 'Agregar jugador', method: :add_player },
          '4' => { text: 'Listar jugadores', method: :list_players },
          '5' => { text: 'Comenzar campeonato', method: :start_championship },
          '6' => { text: 'Salir', method: :exit }
        }
        display_menu(options)
        handle_user_input(options, nil)
      end

      while !@@exit
        options = {
          '1' => { text: 'Ver fixture', method: :display_fixture },
          '2' => { text: 'Ingresar resultado proximo partido', method: :next_match },
          '3' => { text: 'Ver tabla posiciones', method: :display_table },
          '4' => { text: 'Salir', method: :exit }
        }
        display_menu(options)
        handle_user_input(options, nil)
      end
    end
  end
end

Program.run
