require '../../utilities/utils.rb'

def outcome(they, we)
  if we + 3 - they == 4 || (they == 2 && we == 0)
    :win
  elsif we == they
    :draw
  else
    :lose
  end
end

TYPES = { 'A' => 0, 'B' => 1, 'C' => 2, 'X' => 0, 'Y' => 1, 'Z' => 2}
input = readlines('input.txt').map(&:split).map{ |entry| entry.map { |value| TYPES[value] } }

def day02a(input)
  input.map do |they, we|
    reward = nil
    choice = we

    case outcome(they, we)
    when :win
      reward = 6
    when :draw
      reward = 3
    when :lose
      reward = 0
    end

    choice + reward + 1 # +1 to make up for them using 123 rather than 012
  end.sum
end

def day02b(input)
  input.map do |they, action|
    reward = nil
    choice = nil

    case action
    when 0 # lose
      reward = 0
      choice = (they - 1) % 3 # their choice rolled back by one
    when 1 # draw
      reward = 3
      choice = they # exactly their choice
    when 2 # win
      reward = 6
      choice = (they + 1) % 3 # their choice rolled forward by one
    end

    choice + reward + 1 # +1 to make up for them using 123 rather than 012
  end.sum
end

puts 'Day 02:'
puts "  Part A: #{day02a(input)}"
puts "  Part B: #{day02b(input)}"
