require_relative "tile.rb"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9){Array.new(9, " ")}
  end

  def set_bombs
    10.times do 
      row, col = self.find_open.sample
      @grid[row][col] = Tile.new(:b, [row, col])
    end
    true
  end

  def set_tiles
    self.find_open.each do |space|
      row, col = space
      @grid[row][col] = Tile.new("_", [row, col])
    end
    true
  end

  def find_open 
    open_spaces = []
    (0...@grid.length).each do |row|
      (0...@grid.length).each do |col|
        open_spaces << [row, col] if @grid[row][col] == " "
      end
    end
    open_spaces
  end

  def set_fringe
    (0...@grid.length).each do |row|
      (0...@grid.length).each do |col|
        next if @grid[row][col].is_bomb?
        adj = @grid[row][col].neighbors
        @grid[row][col].neighbor_bomb_count(count_neighbors(adj))
      end
    end
    true
  end

  def count_neighbors(neighbors)
    count = 0
    neighbors.each do |coord|
      row, col = coord
      count += 1 if @grid[row][col].is_bomb? 
    end
    return "_" if count == 0
    count 
  end

  def show_board
    board.each.with_index do |row|
     puts row.join(" ")
    end
    true
  end

  def board
    copy = @grid.map do |row|
      row.map do |tile|
        if tile.is_revealed? 
          tile.to_s
        elsif tile.is_flagged?
          "F"
        else
          "*"
        end
      end
    end
    copy
  end

  def flip_flag_space(coord)
    row, col = coord
    @grid[row][col].flip_flag
  end

  def reveal_space(coord)
    row, col = coord
    unless @grid[row][col].is_revealed?
      @grid[row][col].reveal
      if @grid[row][col].is_bomb?
        return false
      elsif grid[row][col].type.is_a?(Integer)
        return true
      else
        @grid[row][col].neighbors.each do |coords|
          reveal_space(coords)
        end
      end
    end
    true
  end

end