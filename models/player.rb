class Player
  attr_accessor :name, :age, :id

  def initialize(name, age, id)
    @name = name
    @age = age
    @id = id
  end

  def to_s
    "#{@name} (#{@id}) - #{@age}"
  end
end
