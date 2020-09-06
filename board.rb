require_relative "tile.rb"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9){Array.new(9, " ")}
  end

  

end