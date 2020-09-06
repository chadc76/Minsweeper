class Tile
  require "colorize"
  attr_reader :type, :bomb
  def initialize(type, coordinates)
    @type = type
    @bomb = is_bomb?
    @flagged = false
    @revealed = false
    @coordinates = coordinates
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

  def neighbors
    row, col = @coordinates
    neighbors = []
    (-1..1).each do |first|
      (-1..1).each do |second|
        new_row = row - first
        new_col = col - second
        neighbors << [new_row, new_col] if is_valid?(new_row) && is_valid?(new_col) && [new_row, new_col] != @coordinates
      end
    end
    neighbors
  end

  def is_valid?(num)
    num >= 0 && num < 9
  end

  def neighbor_bomb_count(count)
    @type = count 
  end

  def to_s
    if @type == :b
      new_val = @type.to_s.colorize(:red)
    elsif @type == 1
      new_val = @type.to_s.colorize(:blue)
    elsif @type == 2
      new_val = @type.to_s.colorize(:green)
    elsif @type == 3
      new_val = @type.to_s.colorize(:yellow)
    elsif @type == 4
      new_val = @type.to_s.colorize(:magenta)
    elsif @type == 5
      new_val = @type.to_s.colorize(:cyan)
    elsif @type == 6
      new_val = @type.to_s.colorize(:light_green)
    elsif @type == 7
      new_val = @type.to_s.colorize(:light_blue)
    elsif @type == 8
      new_val = @type.to_s.colorize(:light_magenta)
    else
      new_val = @type
    end
    new_val
  end

end