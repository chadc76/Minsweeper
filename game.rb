require_relative "board.rb"
require_relative "tile.rb"
require_relative "highscores.rb"
require "yaml"
require "io/console"

class Minesweeper
    attr_reader :board, :player
  def initialize(player)
    level = get_level
    @level = level
    @board = Board.new(@level)
    @player = player
    @last_pos = [0,0]
  end

  def run
    system("clear")
    @board.populate if @board.grid.flatten.all?{|el| el == " "}
    take_turn
    starting = Time.now
    until game_over?
      puts "#{flags_remaining_to_be_placed} mines remaining"
      take_turn
      system("clear")
    end
    ending = Time.now
    elapsed = ending - starting
    elapsed
    if board.won?
      puts "Congratulation, you won! You won in #{elapsed} seconds"
      board.flag_mines
      board.show_board
      show_highscores(@level, elapsed)
    else
      puts "Sorry, you hit a mine at #{@last_pos}! You lose!"
      board.flag_mines
      board.show_board
      highscores = YAML.load(File.read("#{@level}.yml"))
      highscores.print
    end
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

  def show_highscores(level, time)
    highscores = YAML.load(File.read("#{level}.yml"))
    highscores.add_item(player, time.to_s)
    highscores.print
    File.open("#{level}.yml", "w") { |file| file.write(highscores.to_yaml) }
  end

  def flags_placed
    board.grid.flatten.count { |tile| tile.is_flagged?}
  end

  def flags_remaining_to_be_placed
    board.num_of_mines - flags_placed
  end

  def move_on_board
    system("clear")
    puts "#{flags_remaining_to_be_placed} mines remaining"
    board.highlighted_board(@last_pos)
    puts "move to position or Hit TAB to save game:"
    puts "Hit ENTER to reveal the space, Hit SPACE to flag a mine" 
    puts
    moves = ["UP ARROW", "DOWN ARROW", "LEFT ARROW", "RIGHT ARROW", "SPACE", "RETURN", "TAB"]
    move = 0
    until moves.include?(move)
    move = show_single_key
    end

    case move
    when "UP ARROW"
      if @last_pos[0] == 0
        return true
      else
       @last_pos[0] -= 1
      end
    when "DOWN ARROW"
      if @last_pos[0] == board.size[0] - 1
        return true
      else
        @last_pos[0] += 1
      end
    when "RIGHT ARROW"
      if @last_pos[1] == board.size[1] - 1
        return true
      else
        @last_pos[1] += 1
      end
    when "LEFT ARROW"
      if @last_pos[1] == 0
        return true
      else
        @last_pos[1] -= 1
      end
    when "RETURN"
      return "r"
    when "SPACE"
      return "f"
    when "TAB"
      return "s"
    end
    true
  end

  def take_turn
    move = ""
    until move == "r" || move == "f" || move == "s"
      move = move_on_board
    end
    save_game if move == "s"
    make_move(@last_pos, move)
  end

  def game_over?
    board.won? || board.lose?
  end

  def make_move(pos, move)
    move == "r" ? board.reveal_space(pos) : board.flip_flag_space(pos)
    false
  end

  def save_game
    puts "Enter file name:"
    name = gets.chomp + ".yml"
    File.open(name, "w") { |file| file.write(self.to_yaml) }
    puts "Game saved as #{name}"
    exit
  end

  # Reads keypresses from the user including 2 and 3 escape character sequences.
 def read_char
   STDIN.echo = false
   STDIN.raw!

   input = STDIN.getc.chr
   if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
   end
 ensure
   STDIN.echo = true
   STDIN.cooked!

   return input
 end
 def show_single_key
   c = read_char

   case c
   when " "
     return "SPACE"
   when "\t"
     return "TAB"
   when "\r"
     return "RETURN"
   when "\n"
     return "LINE FEED"
   when "\e"
     return "ESCAPE"
   when "\e[A"
     return "UP ARROW"
   when "\e[B"
     return "DOWN ARROW"
   when "\e[C"
     return "RIGHT ARROW"
   when "\e[D"
     return "LEFT ARROW"
   when "\177"
     return "BACKSPACE"
   when "\004"
     return "DELETE"
   when "\e[3~"
     return "ALTERNATE DELETE"
   when "\u0003"
     puts "exit"
     exit 0
   when /^.$/
     return "#{c.inspect}"
   else
     return  "#{c.inspect}"
   end
 end
end

system("clear")

if __FILE__ == $PROGRAM_NAME
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