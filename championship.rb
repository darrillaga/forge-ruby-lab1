require_relative 'team'
require_relative 'player'
require_relative 'match'

class Championship
  def initialize(name, team_players_count)
    @name = name
    @team_players_count = team_players_count.to_i

    @teams = {}
    @players = []
    @fixture = []
  end

  def summary
    "### Campeonato #{@name} (#{@team_players_count} jugadores)"
  end

  def add_team(team_name)
    unless @teams.has_key?(team_name)
      @teams[team_name] = Team.new(team_name)
    else
      puts 'Error. Ya existe un equipo con ese nombre'
    end
  end

  def print_teams
    @teams.each do |team_name, team|
      puts team.summary
    end
  end

  def add_player(team_name, ci, full_name, age)
    if @teams.has_key?(team_name)
      player_with_ci = @players.find{ |player| player.ci == ci }
      if player_with_ci
        puts 'Error. Ya existe un jugador con la ci indicada'
      else
        player = Player.new(ci, full_name, age)
        @teams[team_name].add_player(player)
        @players << player
      end
    else
      puts "Error. No existe un equipo con el nombre #{team_name}"
    end
  end

  def print_players(team_name)
    if @teams.has_key?(team_name)
      @teams[team_name].players.each do |player|
        puts player.summary
      end
    else
      puts "Error. No existe un equipo con el nombre #{team_name}"
    end
  end

  def generate_fixture
    return unless check_championship_start

    @fixture = []

    teams = @teams.keys
    rounds = teams.length - 1
    matches_per_round = teams.length / 2

    rounds.times do |round|
      round = []
      matches_per_round.times do |i|
        match = Match.new(@teams[teams[i]], @teams[teams[rounds - i]])
        round << match
      end

      @fixture << round
      teams = rotate_teams(teams)
    end

    true
  end

  def print_fixture
    @fixture.each_with_index do |round, index|
      puts "Fecha #{index+1}"
      round.each do |match|
        puts match.summary
      end
    end
  end

  def next_match
    @current_round ||= 0
    @current_match ||= 0

    if @fixture[@current_round] && @current_match >= @fixture[@current_round].length
      @current_round += 1
      @current_match = 0
    end

    if @fixture[@current_round]
      match = @fixture[@current_round][@current_match]
      @current_match += 1

      puts match.title

      match
    else
      puts 'No hay mas partidos'
    end
  end

  def set_match_result(match, score_team_a, score_team_b)
    match.set_result(score_team_a, score_team_b)
  end

  def print_table
    puts 'Equipo        | PJ | PG | PE | PP | Puntos'
    @teams.each do |team_name, team|
      data = team.table_data
      print "#{team_name}     |"
      puts "#{data[:played]} | #{data[:won]} | #{data[:draw]} | #{data[:lost] } | #{data[:points]}"
    end
  end

  private

  def rotate_teams(teams)
    team = teams.slice!(1, 1)
    teams.push(team.first)
  end

  def check_championship_start
    unless @teams.length % 2 == 0
      puts 'Error. Es necesario un numero par de equipos'
      return false
    end

    not_valid_teams = @teams.values.select{ |team| team.players.count != @team_players_count }
    if not_valid_teams.any?
      puts 'Error. Hay equipos que no tienen la cantidad de jugadores esperada'
      return false
    end

    true
  end
end
