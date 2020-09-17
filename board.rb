require_relative "tile.rb"
require "colorize"
class Board
  attr_reader :grid, :level, :size, :num_of_mines

  def initialize(level)
    @level = level
    @size, @num_of_mines = get_level(level)
    n,m = size
    @grid = Array.new(n){Array.new(m, " ")}
  end

  def get_level(level)
    levels = {"Beginner"=>[[9,9],10], "Intermediate"=>[[16, 16],40], "Expert"=>[ [16,30], 99] }
    result = []
    if levels.has_key?(level)
      result = levels[level]
    else
      result = get_custom
    end
    result
  end

  def get_custom
    puts "Enter height of board:"
    n = gets.chomp.to_i
    puts "Enter width of board:" 
    m = gets.chomp.to_i
    puts "Enter number of mines on board:"
    mines = gets.chomp.to_i
    [[n,m], mines]
  end

  def populate
    set_mines
    set_tiles
    set_fringe
  end

  def won?
    grid.flatten.all? { |tile| tile.is_mine? || tile.is_revealed? }
  end

  def lose?
    grid.flatten.any? { |tile| tile.is_mine? && tile.is_revealed? }
  end

  def set_mines
    num_of_mines.times do 
      row, col = self.find_open.sample
      @grid[row][col] = Tile.new(:m, [row, col], size)
    end
    true
  end

  def set_tiles
    self.find_open.each do |space|
      row, col = space
      @grid[row][col] = Tile.new("_", [row, col], size)
    end
    true
  end

  def find_open 
    open_spaces = []
    (0...size[0]).each do |row|
      (0...size[1]).each do |col|
        open_spaces << [row, col] if @grid[row][col] == " "
      end
    end
    open_spaces
  end

  def flag_mines
    @grid.each do |row|
      row.each { |tile| tile.flip_flag if tile.is_mine? && !tile.is_revealed? && !tile.is_flagged?}
    end
    true
  end

  def set_fringe
    (0...size[0]).each do |row|
      (0...size[1]).each do |col|
        next if @grid[row][col].is_mine?
        adj = @grid[row][col].neighbors
        @grid[row][col].neighbor_mine_count(count_neighbors(adj))
      end
    end
    true
  end

  def count_neighbors(neighbors)
    count = 0
    neighbors.each do |coord|
      row, col = coord
      count += 1 if @grid[row][col].is_mine? 
    end
    return "_" if count == 0
    count 
  end

  def show_board(b = board)
    b.each do |row|
      rows = ""
      row.each do |col|
        rows += "#{col} "
      end
      puts "#{rows}"
    end
    true
  end

  def board
    copy = @grid.map do |row|
      row.map do |tile|
        if tile.is_revealed? 
          tile.to_s
        elsif tile.is_flagged?
          "F".colorize(:red)
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
      if @grid[row][col].is_mine?
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

  def highlighted_board(pos)
    copy = board.map do |row|
      row.map do |tile|
        tile
      end
    end
    
    copy.each_with_index do |row, idx_1|
      row.each_with_index do |tile, idx_2|
        if pos == [idx_1, idx_2]
          if tile == "*"
           copy[idx_1][idx_2] = "*".black.on_white
          elsif tile == "F"
            copy[idx_1][idx_2] = "F".red.on_white
          else
            copy[idx_1][idx_2] = tile.on_white
          end
        end
      end
    end

    show_board(copy)
  end

end