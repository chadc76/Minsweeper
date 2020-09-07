require_relative "board.rb"
require_relative "tile.rb"
require "yaml"

class Minesweeper
    attr_reader :board, :player
  def initialize(player)
    @level = get_level
    @board = Board.new(@level)
    @player = player
    @last_pos = []
  end

  def run
    system("clear")
    @board.populate if @board.grid.flatten.all?{|el| el == " "}
    puts "#{flags_remaining_to_be_placed} flags left"
    board.show_board
    take_turn
    starting = Time.now
    until game_over?
      puts "#{flags_remaining_to_be_placed} mines remaining"
      board.show_board
      take_turn
      system("clear")
    end
    ending = Time.now
    elapsed = ending - starting
    elapsed
    if board.won?
      puts "Congratulation, you won! You won in #{elapsed} seconds"
    else
      puts "Sorry, you hit a mine at #{@last_pos}! You lose!"
    end
    board.flag_mines
    board.show_board
    true
  end

  def get_level
    levels = {"B" => "Beginner", "I" => "Intermediate", "E" => "Expert", "C" => "Custom"}
    level = ""
    until levels.has_key?(level)
      system("clear")
      puts "Enter level:"
      puts "Beginner, 9x9 board with 10 mines, Enter 'B'"
      puts "Intermediate, 16x16 board with 40 mines, Enter 'I'"
      puts "Expert, 16x30 board with 99 mines, Enter 'E'"
      puts "for a custom board, Enter 'C'"
      level = gets.chomp.upcase
    end
    levels[level]
  end

  def flags_placed
    board.grid.flatten.count { |tile| tile.is_flagged?}
  end

  def flags_remaining_to_be_placed
    board.num_of_mines - flags_placed
  end

  def take_turn
    pos = get_pos
    move = get_move(pos)
    make_move(pos, move)
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
    if pos.length != 2 || row < 0 || row > board.size[0] || col < 0 || col > board.size[1]
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
    response = gets.chomp.upcase
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