require 'set'

ORTHO_NEIGHBORHOOD = [
  [1, 0, 0],
  [0, 1, 0],
  [0, 0, 1],
  [-1, 0, 0],
  [0, -1, 0],
  [0, 0, -1]
]

def gen_neighbors(coords)
  ORTHO_NEIGHBORHOOD.map do |neighbor_coord|
    coords.zip(neighbor_coord).map(&:sum)
  end
end

def gen_lava_neighbors(coords, lava)
  gen_neighbors(coords).select do |neigbhor_coord|
    lava.include?(neigbhor_coord)
  end
end

def gen_air_neighbors(coords, lava)
  gen_neighbors(coords).reject do |neigbhor_coord|
    lava.include?(neigbhor_coord)
  end
end

def in_bounding_box?(coords, min, max)
  coords.zip(min).all?{|coord,min_coord|coord>=min_coord} && coords.zip(max).all?{|coord,max_coord|coord<=max_coord}
end

lava = Set.new
min = [Float::INFINITY] * 3
max = [-Float::INFINITY] * 3

File.readlines('input.txt', chomp: true).each do |line|
  coords = line.split(',').map(&:to_i)
  min = min.zip(coords).map(&:min)
  max = max.zip(coords).map(&:max)
  lava.add(coords)
end

lava_neighbors = {}
air_neighbors = {}

lava.each do |coords|
  lava_neighbors[coords] = gen_lava_neighbors(coords, lava)
  air_neighbors[coords] = gen_air_neighbors(coords, lava)
end

def day18a(lava_neighbors, min, max)
  num_exposed_faces =
    lava_neighbors.map do |coord, coord_neighbors|
      6 - coord_neighbors.length
    end.sum

  num_exposed_faces
end

def flood_fill(lava, min, max)
  min = min.zip([-1, -1, -1]).map(&:sum)
  max = max.zip([1, 1, 1]).map(&:sum)

  starting_point = min
  filled = Set.new
  frontier = [min]

  distances = Hash.new(Float::INFINITY)

  until frontier.empty?
    frontier_node = frontier.pop

    distances[frontier_node] = frontier_node.zip(starting_point).map{ |ce, se| ce - se }.sum
    filled.add(frontier_node)

    frontier_node_neighbors =
      gen_air_neighbors(frontier_node, lava).select do |frontier_node_neighbor|
        in_bounding_box?(frontier_node_neighbor, min, max) &&
        !filled.include?(frontier_node_neighbor)
      end

    frontier_node_neighbors.each do |frontier_node_neighbor|
      frontier.push(frontier_node_neighbor)
    end
  end

  distances
end

# Find all surface blocks
# Iterate through each air_neighbor of each surface block
# Count it if it has a distance of less than infinity
def day18b(lava, lava_neighbors, min, max)
  distances = flood_fill(lava, min, max)

  outside_coords = Set.new

  distances.each do |air_node, _|
    gen_neighbors(air_node).each do |air_node_neighbor|
      if lava.include?(air_node_neighbor)
        outside_coords.add(air_node_neighbor)
      end
    end
  end

  num_exposed_faces =
    lava_neighbors.map do |coords, coord_neighbors|
      outside_coords.include?(coords) ? (6 - coord_neighbors.length) : 0
    end.sum

  num_exposed_faces
end

puts 'Day 18:'
puts "  Part A: #{day18a(lava_neighbors, min, max)}"
puts "  Part B: #{day18b(lava, lava_neighbors, min, max)}"
