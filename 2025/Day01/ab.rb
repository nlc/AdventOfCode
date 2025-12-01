def day01a(input)
  s = 50
  input.sum do |ds|
    (0 == s = (s + ds) % 100) ? 1 : 0
  end
end

def day01b(input)
  c = 0
  s = 50
  input.each do |ds|
    lo, hi = [s, s + ds].sort
    c += (hi / 100.0).floor - (lo / 100.0).ceil - ((s % 100) == 0 ? 1 : 0) + 1

    s = s + ds
  end

  c
end

input =
  File.readlines('input.txt', chomp: true).map do |line|
    d, n = line.match(/([LR])(\d+)/).to_a[1..2]
    n.to_i * (d == 'R' ? 1 : -1)
  end

puts "Day 01:"
puts "  Part A: #{day01a(input)}"
puts "  Part B: #{day01b(input)}"
