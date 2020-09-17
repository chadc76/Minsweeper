require_relative "score.rb"

class Highscores

  LINE_WIDTH = 49
  INDEX_COL_WIDTH = 5
  ITEM_COL_WIDTH = 20
  DEADLINE_COL_WIDTH = 10
  CHECKMARK = "\u2713".force_encoding('utf-8')

  attr_accessor :label

  def initialize(level)
    @label = level
    @scores = []
  end
    
  def add_item(name, time)
    @scores << Score.new(name, time)
  end

  def size
    @scores.length
  end

  def valid_index?(index)
    0 <= index && index < self.size
  end

  def [](index)
    return nil if !valid_index?(index)
    @scores[index]
  end

  def print
    puts "-" * LINE_WIDTH
    puts " " * 16 + self.label.upcase
    puts "-" * LINE_WIDTH
    puts "#{'#'.ljust(INDEX_COL_WIDTH)} | #{'Name'.ljust(ITEM_COL_WIDTH)} | #{'Time'.ljust(DEADLINE_COL_WIDTH)}"
    puts "-" * LINE_WIDTH
    sort_by_time!
    @scores.each.with_index do |item, i|
      break if  i == 10
      puts "#{(i + 1).to_s.ljust(INDEX_COL_WIDTH)} | #{item.name.ljust(ITEM_COL_WIDTH)} | #{item.time.to_s} s".ljust(DEADLINE_COL_WIDTH)
    end
    puts "-" * LINE_WIDTH
  end

  def sort_by_time!
    @scores.sort_by! { |score| score.time }
  end
end