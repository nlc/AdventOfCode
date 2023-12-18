require 'set'

DIRECTIONS = {
  'R' => [ 1,  0],
  'U' => [ 0, -1],
  'L' => [-1,  0],
  'D' => [ 0,  1]
}

def vadd(a, b)
  a.zip(b).map { |ea, eb| ea + eb }
end

def walk(position, direction, distance, trenched)
  distance.times do
    position = vadd(position, DIRECTIONS[direction])
    trenched[position] = true
  end

  position
end

def get_neighbors(point)
  DIRECTIONS.map do |_, vector|
    vadd(point, vector)
  end
end

def flood_fill(starting_point, trenched, bounds)
  min_x, min_y, max_x, max_y = bounds
  filled = Set.new
  trenched.each do |point, _|
    filled.add(point)
  end
  filled.add(starting_point)

  p filled

  frontier = [starting_point]

  until frontier.empty?
    frontier_node = frontier.pop

    filled.add(frontier_node)

    frontier_node_neighbors =
      get_neighbors(frontier_node).select do |frontier_node_neighbor|
        min_x <= frontier_node_neighbor[0] &&
        min_y <= frontier_node_neighbor[1] &&
        max_x >= frontier_node_neighbor[0] &&
        max_y >= frontier_node_neighbor[1] &&
        !filled.include?(frontier_node_neighbor)
      end

    # p "#{frontier_node_neighbors.count} valid neighbors"

    frontier_node_neighbors.each do |frontier_node_neighbor|
      frontier.push(frontier_node_neighbor)
    end

    # p frontier
  end

  filled
end

fname = ARGV.shift || 'input.txt'

data =
  File.readlines(fname, chomp: true).map do |line|
    direction, distance, color = line.match(/([RULD]) (\d+) \(\#([0-9a-f]{6})\)/).to_a.drop(1)
    [direction, distance.to_i, color]
  end

position = [0, 0]
trenched = {}

data.each do |datum|
  position = walk(position, datum[0], datum[1], trenched)
end

min_x = trenched.keys.min_by { |x, y| x }[0] - 1
min_y = trenched.keys.min_by { |x, y| y }[1] - 1
max_x = trenched.keys.max_by { |x, y| x }[0] + 1
max_y = trenched.keys.max_by { |x, y| y }[1] + 1

(min_y..max_y).to_a.each do |y|
  (min_x..max_x).to_a.each do |x|
    if trenched.include?([x, y])
      print '#'
    else
      print '.'
    end
  end
  puts
end

filled = flood_fill([1, 1], trenched, [min_x, min_y, max_x, max_y])

(min_y..max_y).to_a.each do |y|
  (min_x..max_x).to_a.each do |x|
    if filled.include?([x, y])
      print '#'
    else
      print '.'
    end
  end
  puts
end

puts filled.count
