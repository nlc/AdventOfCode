chunks = File.read('input.txt').split(/\n\n/).map{|chunk|chunk.split(/\n/).map(&:to_i)}

day01a = chunks.max_by{|chunk|chunk.sum}.sum
day01b = chunks.sort_by{|chunk|chunk.sum}.last(3).flatten.sum

puts 'Day 01:'
puts "  Part A: #{day01a}"
puts "  Part B: #{day01b}"

# Notes from collaboration:
#   * Array#max takes an integer argument!
#   * can use Array#slice_when to cut on a condition
