def idx_first_nonrepeat(string, length)
  first_nonrepeat =
    string.chars.each_cons(length).select do |subseq|
      subseq.uniq.length == length
    end.first.join

  string.index(first_nonrepeat) + length
end

def day06a(input)
  idx_first_nonrepeat(input, 4)
end

def day06b(input)
  idx_first_nonrepeat(input, 14)
end

input = File.read('input.txt')

puts 'Day 06:'
puts "  Part A: #{day06a(input)}"
puts "  Part B: #{day06b(input)}"
