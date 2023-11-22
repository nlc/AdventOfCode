require 'set'
require 'byebug'


class Lava
  ORTHO_NEIGHBORHOOD = [
    [1, 0, 0],
    [0, 1, 0],
    [0, 0, 1],
    [-1, 0, 0],
    [0, -1, 0],
    [0, 0, -1]
  ]

  def initialize(fname = 'input.txt')
    @lava = Set.new
    @min = [Float::INFINITY] * 3
    @max = [-Float::INFINITY] * 3

    File.readlines(fname, chomp: true).each do |line|
      coords = line.split(',').map(&:to_i)
      @min = @min.zip(coords).map(&:min)
      @max = @max.zip(coords).map(&:max)
      @lava.add(coords)
    end

    # Expand the bounding box a bit just to give the flood fill some room to breathe
    @min = @min.zip([-1, -1, -1]).map(&:sum)
    @max = @max.zip([1, 1, 1]).map(&:sum)

    @neighbors = {}
    @lava_neighbors = {}
    @air_neighbors = {}

    @outside = Set.new
    flood_fill.each do |coord, _distance|
      get_lava_neighbors(coord).each do |coord_lava_neighbor|
        @outside.add(coord_lava_neighbor)
      end
    end
  end

  def get_neighbors(coords)
    @neighbors[coords] ||=
      ORTHO_NEIGHBORHOOD.map do |neighbor_coord|
        coords.zip(neighbor_coord).map(&:sum)
      end
  end

  def get_lava_neighbors(coords)
    @lava_neighbors[coords] ||=
      get_neighbors(coords).select do |neigbhor_coord|
        @lava.include?(neigbhor_coord)
      end
  end

  def get_air_neighbors(coords)
    @air_neighbors[coords] ||=
      get_neighbors(coords).reject do |neigbhor_coord|
        @lava.include?(neigbhor_coord)
      end
  end

  def in_bounding_box?(coords)
    coords.zip(@min).all?{|coord,min_coord|coord>=min_coord} &&
    coords.zip(@max).all?{|coord,max_coord|coord<=max_coord}
  end

  def each(&block)
    @lava.each do |lava_coord|
      block.call(lava_coord)
    end
  end

  def map(&block)
    @lava.map do |lava_coord|
      block.call(lava_coord)
    end
  end

  def flood_fill(starting_point = [0, 0, 0])
    return {} if @lava.include?(starting_point)

    filled = Set.new
    filled.add(starting_point)
    frontier = [starting_point]

    @distance_from_origin = Hash.new(Float::INFINITY)
    @distance_from_origin[starting_point] = 0

    until frontier.empty?
      frontier_node = frontier.pop

      @distance_from_origin[frontier_node] = frontier_node.zip(starting_point).map{ |ce, se| ce - se }.sum
      filled.add(frontier_node)

      frontier_node_neighbors =
        get_air_neighbors(frontier_node).select do |frontier_node_neighbor|
          in_bounding_box?(frontier_node_neighbor) &&
          !filled.include?(frontier_node_neighbor)
        end

      frontier_node_neighbors.each do |frontier_node_neighbor|
        frontier.push(frontier_node_neighbor)
      end
    end

    @distance_from_origin
  end

  def total_surface_area
    @lava.map do |lava_coord|
      get_air_neighbors(lava_coord).count
    end.sum
  end

  def external_surface_area
    @outside.map do |outside_coord|
      get_air_neighbors(outside_coord).select do |outside_coord_air_neighbor|
        @distance_from_origin[outside_coord_air_neighbor] < Float::INFINITY
      end.length
    end.sum
  end
end

def day18a(lava)
  lava.total_surface_area
end

# Find all surface blocks
# Iterate through each air_neighbor of each surface block
# Count it if it has a distance of less than infinity
def day18b(lava)
  lava.external_surface_area
end

lava = Lava.new('input.txt')

puts 'Day 18:'
puts "  Part A: #{day18a(lava)}"
puts "  Part B: #{day18b(lava)}"
