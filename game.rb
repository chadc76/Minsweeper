require_relative "board.rb"
require_relative "tile.rb"

class Minesweeper
    attr_reader :board, :player
  def initialize(player)
    @board = Board.new
    @player = player
  end

  def get_pos
    pos = nil
    until valid_pos(pos)
      puts "#{player}, Enter the posistion you want to make your move at (ie. '1,1'):"
      pos = gets.chomp.split(",").map(&:to_i)
    end
    pos
  end

  def get_move(pos)
    puts "type 'r' if you want to reveal this space, type 'f' if you want to flag or unflag this space"
    move = gets.chomp
    if move == "r" and board.grid[row][col].is_flagged?
      puts "you must unflag this posistion before you can reveal it"
      get_move(pos)
    end
    move
  end

  def valid_pos(pos)
    return false if pos == nil 
    row, col = pos
    if pos.length != 2 || row < 0 || row > 8 || col < 0 || col > 8
      puts "posistion is not valid!"
      return false
    elsif board.grid[row][col].is_revealed?
      puts "that space has already been revealed"
      return false
    end
    true 
  end

end