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

def neighbors(coords)
  $unit_vectors.map do |_direction, unit_vector|
    _coords = coords.dup
    3.times do |i|
      _coords[i] += unit_vector[i]
    end
    _coords
  end
end

# Black: 0,3..6 -> White
# White: 2 -> Black
def rule(tiles)
  coords_in_play = []
  tiles.each do |coords, state|
    # we only have to consider the ones that are on
    # OR are touching ones that are on
    if state
      coords_in_play << coords
      coords_in_play += neighbors(coords)
    end
  end
  coords_in_play.uniq!

  new_tiles = {}
  coords_in_play.each do |coord|
    active_neighbors =
      neighbors(coord).count do |neighbor|
        tiles[neighbor]
      end

    if (tiles[coord] && (1..2).include?(active_neighbors)) ||
       (!tiles[coord] && active_neighbors == 2)
      new_tiles[coord] = true
    end
  end

  new_tiles
end

fname = ARGV.shift || raise('Usage: ruby b.rb <input file name>')
direction_strs = File.readlines(fname, chomp: true)

tiles = {}
tiles.default = false
direction_strs.each do |direction_str|
  tile = follow_path(to_path(parse_directions(direction_str)))
  tiles[tile] = !tiles[tile]
end

# The slowdown around 1000 active cells is a bit oof
pbwidth = 30
100.times do |i|
  tiles = rule(tiles)

  ct = tiles.values.count { |e| e }

  prog= i.to_f / 100
  pct = i
  printf("\033[2K\r %d / 100 ( %d %% ) | %d active tiles", i, pct, ct)

  # progress bar, why not
  puts
  print "\033[2K\r [\033[#{pbwidth + 1}C]\033[#{pbwidth + 2}D"
  print "\033[7m"
  (prog * pbwidth).to_i.times { print ' ' }
  print "\033[0m\033[A\r"
end

puts "\033[2K\r#{tiles.values.count { |e| e }}"
print "\033[2K\r"
