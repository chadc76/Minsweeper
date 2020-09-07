require_relative "board.rb"
require_relative "tile.rb"

class Minesweeper
    attr_reader :board, :player
  def initialize(player)
    @board = Board.new
    @player = player
  end


end