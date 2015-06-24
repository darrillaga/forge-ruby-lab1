class Team
  def initialize(name)
    @name = name
    @players = []

    @results = {
      played: 0,
      won:    0,
      lost:   0,
      draw:   0
    }
    @points = 0
  end

  def name
    @name
  end

  def summary
    "#{@name} (#{@players.count} jugadores)"
  end

  def add_player(player)
    @players << player
  end

  def players
    @players
  end

  def add_match_win
    @results[:played] += 1
    @results[:won] += 1
    @points += 3
  end

  def add_match_lost
    @results[:played] += 1
    @results[:lost] += 1
  end

  def add_match_draw
    @results[:played] += 1
    @results[:draw] += 1
    @points += 1
  end

  def table_data
    @results.merge({ points: @points })
  end
end
