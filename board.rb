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

end