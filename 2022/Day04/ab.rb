require 'set'

input = File.readlines('input.txt').map do |line|
  line.split(/,/).map do |entry|
    Set.new((eval(entry.gsub(/-/, '..'))).to_a) # Forgive me, for I have sinned
  end
end

def day04a(input)
  input.count do |a, b|
    a.superset?(b) || b.superset?(a)
  end
end

def day04b(input)
  input.count do |a, b|
    a.intersect?(b)
  end
end

puts 'Day 01:'
puts "  Part A: #{day04a(input)}"
puts "  Part B: #{day04b(input)}"
