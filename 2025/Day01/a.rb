input =
  File.readlines('input.txt', chomp: true).map do |line|
    d, n = line.match(/([LR])(\d+)/).to_a[1..2]
    n.to_i * (d == 'R' ? 1 : -1)
  end

c = 0
s = 50
input.each do |ds|
  c += 1 if 0 == s = (s + ds) % 100
end
# puts c


c = 0
s = 50
input.each do |ds|
  puts "s=#{s}"
  puts "ds=#{ds}"

  print "c=#{c} -> "
  if (s + ds) >= 100
    c += 1
    c += (ds - 100 + s) / 100
  end

  if (s + ds) <= 0
    c -= (ds + s) / 100
    c -= 1 if s == 0
    c += 1 if s + ds == 0
  end

  puts "c=#{c}"

  s = (s + ds) % 100
end
puts c
