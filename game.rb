require_relative "board.rb"
require_relative "tile.rb"
require "yaml"

class Minesweeper
    attr_reader :board, :player
  def initialize(player)
    @board = Board.new
    @player = player
    @last_pos = []
  end

  def run
    system("clear")
    @board.populate if @board.grid.flatten.all?{|el| el == " "}
    until game_over?
      take_turn
      system("clear")
    end
    if board.won?
      puts "Congratulation, you won!"
      board.show_board
    else
      puts "Sorry, you hit a bomb at #{@last_pos}! You lose!"
      board.reveal_bombs
      board.show_board
    end
    true
  end

  def take_turn
    board.show_board
    pos = get_pos
    move = get_move(pos)
    make_move(pos, move)
    board.show_board
  end

  def game_over?
    board.won? || board.lose?
  end

  def make_move(pos, move)
    move == "r" ? board.reveal_space(pos) : board.flip_flag_space(pos)
    @last_pos = pos
  end

  def get_pos
    pos = nil
    until valid_pos(pos)
      puts "#{player}, Enter the posistion you want to make your move at (ie. '1,1') or enter 'S' to save game:"
      response = gets.chomp
      save_game if response.upcase == 'S'
      pos = response.split(",").map(&:to_i)
    end
    pos
  end

  def get_move(pos)
    puts "type 'r' if you want to reveal this space, type 'f' if you want to flag or unflag this space"
    move = gets.chomp
    row, col = pos
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

  def save_game
    puts "Enter file name:"
    name = gets.chomp + ".yml"
    File.open(name, "w") { |file| file.write(self.to_yaml) }
    puts "Game saved as #{name}"
    exit
  end
end

if __FILE__ == $PROGRAM_NAME
  system ("Clear")
  puts "Welcome to Minsweeper"
  puts "Type 'N' to begin a new game or 'L' to load a saved game"
  response = ""
  until response == "N" || response == "L"
    response = gets.chomp
  end

  if response == "N"
    puts "Enter name:"
    name = gets.chomp
    new_game = Minesweeper.new(name)
    new_game.run
  else
    puts "Enter file name:"
    name = gets.chomp
    new_game = YAML.load(File.read(name))
    new_game.run
  end
end