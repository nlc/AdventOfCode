require 'set'

require_relative '../../utilities/utils.rb'

class Walker < WalkerBase
end

def grid_at(loc)
  x, y = loc

  GRID[y][x]
end

def print_grid
  GRID.each do |line|
    puts line.join
  end
end

# ifname = 'sample.txt'
ifname = ARGV.shift || 'input.txt'

if ifname == 'input.txt'
  grid_size = 71
  num_coords = 1024
else
  grid_size = 7
  num_coords = 12
end

DIRS = [
  [ 1,  0],
  [ 0,  1],
  [-1,  0],
  [ 0, -1]
]

drop_coords = File.readlines(ifname, chomp: true).first(num_coords).map { |line| line.split(/,/).map(&:to_i) }

GRID = Array.new(grid_size) { Array.new(grid_size) { '.' } }
GRID_BOUNDS = [[0, GRID.first.length], [0, GRID.length]]

drop_coords.each do |x, y|
  p [x, y]
  GRID[y][x] = '#'
end

start_loc = [0, 0]
end_loc = [GRID.last.length - 1, GRID.length - 1]

def lowest_maze_score(loc, end_loc, visited = {})
  # puts "called @#{loc.inspect}"

  return 0 if loc == end_loc

  new_visited = visited.merge(loc => true)

  nbrs =
    DIRS.map do |dir|
      nbr = vadd(loc, dir)

      ((!visited.include?(nbr)) && vinbounds?(nbr, GRID_BOUNDS) && (grid_at(nbr) != '#')) ? nbr : nil
    end.compact

  return Float::INFINITY if nbrs.empty?


  res =
    nbrs.map do |nbr|
      lowest_maze_score(nbr, end_loc, new_visited)
    end.min

  1 + res
end

DISTANCES = {}
def distance_from_corner(loc, end_loc, visited = {})
  # puts "called @#{loc.inspect}"

  return 0 if loc == end_loc

  new_visited = visited.merge(loc => true)

  nbrs =
    DIRS.map do |dir|
      nbr = vadd(loc, dir)

      ((!visited.include?(nbr)) && vinbounds?(nbr, GRID_BOUNDS) && (grid_at(nbr) != '#')) ? nbr : nil
    end.compact

  return Float::INFINITY if nbrs.empty?


  res =
    nbrs.map do |nbr|
      lowest_maze_score(nbr, end_loc, new_visited)
    end.min

  1 + res
end

print_grid
exit
lms = lowest_maze_score(start_loc, end_loc)
p "final = #{lms}"
