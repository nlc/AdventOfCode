require 'algorithms'
include Containers

infile = 'input.txt'
num_mins = 5492 # Brute force is easy if you do it in the right place...

points =
  File.readlines(infile, chomp: true).map do |line|
    line.split(/,/).map(&:to_i)
  end

def r2(p1, p2)
  p1.zip(p2).sum{|a, b|(a-b)**2}
end

mh = MinHeap.new([[Float::INFINITY, []]] * num_mins) { |a, b| (a[0] <=> b[0]) == -1 }
points.length.times do |ip1|
  ip1.times do |ip2|
    mh.push([r2(points[ip1], points[ip2]), [ip1, ip2]])
  end
end

5491.times { mh.pop }
_, last_ips = mh.pop
p last_ips.map { |ip| points[ip][0] }.inject(:*)
