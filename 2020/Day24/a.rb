def parse_directions(str)
  str.scan(/(e|se|sw|w|nw|ne)/).flatten
end

$unit_vectors = {
  'e'  => [1, 0, -1],
  'se' => [0, 1, -1],
  'sw' => [-1, 1, 0],
  'w'  => [-1, 0, 1],
  'nw' => [0, -1, 1],
  'ne' => [1, -1, 0]
}

$directions = $unit_vectors.invert

def follow_naive(directions)
  coords = [0, 0, 0]

  directions.each do |direction|
    3.times do |i|
      coords[i] += $unit_vectors[direction][i]
    end
  end

  coords
end

# I believe that move order is irrelevant. If that's the case then we can do
# some simple math on the paths to reduce them to their minimal expression.
def to_path(directions)
  path = directions.uniq.map { |e| [e, directions.count(e)] }.to_h
  path.default = 0
  [%w[e w], %w[se nw], %w[sw ne]].each do |dir, opp|
    m = [path[dir], path[opp]].min
    path[dir] -= m
    path[opp] -= m
  end

  path
end

def follow_path(path)
  coords = [0, 0, 0]

  path.each do |direction, num|
    3.times do |i|
      coords[i] += $unit_vectors[direction][i] * num
    end
  end

  coords
end

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')
direction_strs = File.readlines(fname, chomp: true)

visited = {}
visited.default = 0
direction_strs.each do |direction_str|
  tile = follow_path(to_path(parse_directions(direction_str)))
  visited[tile] += 1
end

puts visited.values.count { |e| e.odd? }
