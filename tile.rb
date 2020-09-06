class Tile
  attr_reader :type, :bomb
  def initialize(type)
    @type = type
    @bomb = is_bomb?
    @flagged = false
    @revealed = false
  end

  def is_bomb?
    type == :b
  end

  def reveal
    @revealed = true
  end

  def flip_flag
    return false if @revealed
    @flagged == false ? @flagged = true : @flagged = false
  end

end