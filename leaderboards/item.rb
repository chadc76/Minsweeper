class Item
    def self.valid_date?(date_string)
        parts = date_string.split("-").map(&:to_i)
        year, month, day = parts
        return false if parts.length != 3
        (1..12).include?(month) && (1..31).include?(day)
    end
    attr_accessor :title, :description
    attr_reader :deadline, :done

    def initialize(title, deadline, description)
        @title = title
        Item.valid_date?(deadline) ? @deadline = deadline : (raise "deadline is not valid")
        @description = description
        @done = false
    end
    
    def deadline=(new_deadline)
        Item.valid_date?(new_deadline) ? @deadline = new_deadline : (raise "deadline is not valid")
    end

    def toggle
        @done = !@done
    end
end