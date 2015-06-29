require 'singleton'

require_relative 'utils/form'
require_relative 'utils/io'
require_relative 'models/player'
require_relative 'models/team'
require_relative 'championship'
require_relative 'test_data'

class Program
  include IOTools
  include Singleton

  EXIT = -1

  def initialize
    championship_form = Form.new('Ingresa la información del campeonato',
      name: 'Nombre del campeonato')

    championship_form.ask_for(:name)
    teams_size = championship_form.select_from_list(
      'Ingresa de cuantos jugadores quieres que sean los equipos: ', [5, 7, 11])

    @championship = Championship.new(*championship_form.get_data)
    @championship.teams_size = teams_size

    TestData.load(@championship)
  end

  def add_team
    form = Form.new('Ingrese nuevo equipo', name: 'Nombre: ', size: 'Tamaño: ')
    form.ask_for(:name, :size)

    @championship.add_team(Team.new(*form.get_data))
  end

  def add_player
    form = Form.new('Ingrese nuevo jugador', name: 'Nombre: ',
      age: 'Edad: ', ci: 'Cédula de Identidad: ')
    form.ask_for(:name, :age, :ci)

    @championship.add_player(Player.new(*form.get_data))
  end

  def add_player_to_team
    form = Form.new

    player = form.select_from_list('Que jugador desea agregar?',
      @championship.players)

    team = form.select_from_list('A que equipo?',
      @championship.teams)

    team.add_player(player)
  end

  def display_players
    display_list(@championship.players)
  end

  def display_teams
    display_list(@championship.teams)
  end

  def next_match
    match = @championship.next_match

    if match
      score_team_a = get_input('Ingresa los goles del primer equipo:')
      score_team_b = get_input('Ingresa los goles del segundo equipo:')

      @championship.set_match_result(match, score_team_a, score_team_b)
    end
  end

  def go_back
    @last_action = :run
  end

  def championship_menu
    @last_action = :championship_menu

    until @last_action == :run  do
      actions = display_menu({
        @championship.name => {
          'Ver Fixture' => :display_fixture,
          'Ingresar resultado próximo partido'  => :next_match,
          'Ver tabla de posiciones' => :print_table,
        },
        'Atras' => :go_back
      })

      print '> '
      option = $stdin.gets.chomp

      send(actions[option.to_i])
    end
  end

  def display_fixture
    @championship.print_fixture
  end

  def go_to_championship
    championship_problems = @championship.can_be_played

    unless championship_problems
      @championship.start unless @championship.started?

      championship_menu
    else
      show_error(championship_problems)

      run
    end
  end

  def display_team_players
    form = Form.new
    team = form.select_from_list('De que equipo desea consultar los jugadores?',
      @championship.teams)

    display_list(team.players)
  end

  def championship_option
    if @championship.started?
      'Continuar campeonato'
    else
      'Comenzar campeonato con los equipos disponibles'
    end
  end

  def print_table
    @championship.print_table
  end

  def exit
    @last_action = EXIT
  end

  def run
    @last_action = :run

    until @last_action == EXIT do
      actions = display_menu({
        'Ingresar Datos' => {
          'Agregar un nuevo jugador' => :add_player,
          'Agregar un nuevo equipo'  => :add_team,
          'Agregar jugador a equipo' => :add_player_to_team,
        },
        'Consultas' => {
          'Ver jugadores ingresados'   => :display_players,
          'Ver equipos ingresados'     => :display_teams,
          'Ver jugadores de un equipo' => :display_team_players
        },
        'Campeonato' => {
          championship_option => :go_to_championship
        },
        'Salir' => :exit
      })

      print '> '
      option = $stdin.gets.chomp

      send(actions[option.to_i])
    end
  end
end

Program.instance.run
