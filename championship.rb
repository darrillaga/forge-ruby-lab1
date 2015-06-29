require_relative 'models/match'

class Championship
  attr_accessor :name, :players, :teams, :teams_size

  def initialize(name)
    @name = name
    @players = []
    @teams = []
    @started = false
    @fixture = []

    @current_round = 0
    @current_match = 0
  end

  def started?
    @started
  end

  def can_be_played
    if !started?
      if @teams.empty?
        return 'No hay equipos para disputar el campeonato'
      elsif @teams.length % 2 != 0
        return 'La cantidad de equipos disponibles debe ser par'
      elsif !@teams.all? { |t| t.available_to_play(teams_size) }
        return 'Hay equipos que tienen menos de la cantidad de jugadores requeridos'
      end
    end
  end

  def start
    unless started?
      @started = true

      generate_fixture
    end
  end

  def add_player(player)
    @players << player
  end

  def add_team(team)
    @teams << team
  end

  def generate_fixture
    @fixture = []

    teams = @teams
    rounds = teams.length - 1
    matches_per_round = teams.length / 2

    rounds.times do |round|
      round = []
      matches_per_round.times do |i|
        match = Match.new(@teams[i], @teams[rounds - i])
        round << match
      end

      @fixture << round
      teams = rotate_teams(teams)
    end

    true
  end

  def next_match
    if @fixture[@current_round] && @current_match >= @fixture[@current_round].length
      @current_round += 1
      @current_match = 0
    end

    if @fixture[@current_round]
      match = @fixture[@current_round][@current_match]
      @current_match += 1

      puts match

      match
    else
      puts 'No hay mas partidos'
    end
  end

  def set_match_result(match, score_team_a, score_team_b)
    match.set_result(score_team_a, score_team_b)
  end

  def print_table
    puts 'Equipo     | PJ | PG | PE | PP | Puntos'

    @teams.each do |team|
      data = team.table_data

      print "#{team.name}          |"
      puts "#{data[:played]} | #{data[:won]} | #{data[:draw]} | #{data[:lost] } | #{data[:points]}"
    end
  end

  def print_fixture
    @fixture.each_with_index do |round, index|
      puts "Fecha #{index+1}"
      round.each do |match|
        puts match
      end
    end
  end

  private

  def rotate_teams(teams)
    team = teams.slice!(1, 1)
    teams.push(team.first)
  end
end
