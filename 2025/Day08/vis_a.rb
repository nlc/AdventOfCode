require 'algorithms'
include Containers

infile = 'input.txt'
num_mins = 1000

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

File.open("first_#{num_mins}_connections.csv", 'w') do |f|
  f.puts "t,ax,ay,az,bx,by,bz"
  num_mins.times do |i|
    dist, ips = mh.pop
    ip1, ip2 = ips
    p1, p2 = ips.map { |ip| points[ip] }

    f.puts [i, *p1, *p2].join(',')
  end
end
