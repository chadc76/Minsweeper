class Tile
  require "colorize"
  attr_reader :type, :mine
  def initialize(type, coordinates, grid_size)
    @type = type
    @mine = is_mine?
    @flagged = false
    @revealed = false
    @coordinates = coordinates
    @grid_size = grid_size
  end

  def is_mine?
    type == :m
  end

  def reveal
    return false if @flagged
    @revealed = true
  end

  def is_revealed?
    @revealed == true
  end

  def is_flagged?
    @flagged == true
  end

  def flip_flag
    return false if @revealed
    @flagged == false ? @flagged = true : @flagged = false
    true
  end

  def neighbors
    row, col = @coordinates
    neighbors = []
    (-1..1).each do |first|
      (-1..1).each do |second|
        new_row = row - first
        new_col = col - second
        neighbors << [new_row, new_col] if new_row_valid?(new_row) && new_col_valid?(new_col) && [new_row, new_col] != @coordinates
      end
    end
    neighbors
  end

  def new_row_valid?(num)
    num >= 0 && num < @grid_size[0]
  end

  def new_col_valid?(num)
    num >= 0 && num < @grid_size[1]
  end

  def neighbor_mine_count(count)
    @type = count 
  end

  def to_s
    if @type == :m
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