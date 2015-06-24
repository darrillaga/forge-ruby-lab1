class Player
  def initialize(ci, full_name, age)
    @ci = ci
    @full_name = full_name
    @age = age
  end

  def ci
    @ci
  end

  def summary
    "#{@ci} - #{@full_name} (#{@age} anios)"
  end
end
