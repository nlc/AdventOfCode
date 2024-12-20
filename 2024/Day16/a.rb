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

# Backwards because it's a left-handed coord system
def turn_left(dir)
  [[0, 1],[-1, 0]].map { |row| vdot(row, dir) }
end

def turn_right(dir)
  [[0, -1],[1, 0]].map { |row| vdot(row, dir) }
end

# ifname = 'sample.txt'
ifname = ARGV.shift || 'input.txt'

GRID = File.readlines(ifname, chomp: true).map(&:chars)

start_loc = nil
end_loc = nil

GRID.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == 'S'
      start_loc = [x, y]
    elsif char == 'E'
      end_loc = [x, y]
    end
  end
end

def lowest_maze_score(loc, dir, visited = {})
  # puts "called @#{loc.inspect}"

  return 0 if grid_at(loc) == 'E'
  return Float::INFINITY if grid_at(loc) == '#'
  return Float::INFINITY if visited[loc]

  forward_loc = vadd(loc, dir)
  left_dir = turn_left(dir)
  left_loc = vadd(loc, left_dir)
  right_dir = turn_right(dir)
  right_loc = vadd(loc, right_dir)

  new_visited = visited.merge(loc => true)

  [
    1001 + lowest_maze_score(left_loc, left_dir, new_visited),
    1 + lowest_maze_score(forward_loc, dir, new_visited),
    1001 + lowest_maze_score(right_loc, right_dir, new_visited)
  ].min
end

# just break my encapsulation why don't ya
$best_so_far = Float::INFINITY
def lowest_maze_score_with_pruning(loc, dir, visited = {}, length_so_far = 0)
  puts length_so_far
  # puts "called @#{loc.inspect}"

  return Float::INFINITY if length_so_far > $best_so_far

  if grid_at(loc) == 'E'
    p $best_so_far = length_so_far
    return 0
  end

  return Float::INFINITY if grid_at(loc) == '#'
  return Float::INFINITY if visited[loc]

  forward_loc = vadd(loc, dir)
  left_dir = turn_left(dir)
  left_loc = vadd(loc, left_dir)
  right_dir = turn_right(dir)
  right_loc = vadd(loc, right_dir)

  new_visited = visited.merge(loc => true)

  forward_score = 1 + lowest_maze_score_with_pruning(forward_loc, dir, new_visited, length_so_far + 1)
  left_score = 1001 + lowest_maze_score_with_pruning(left_loc, left_dir, new_visited, length_so_far + 1)
  right_score = 1001 + lowest_maze_score_with_pruning(right_loc, right_dir, new_visited, length_so_far + 1)

  [forward_score, left_score, right_score].min
end

def shortest_maze_path(loc, dir, visited = {})
  # puts "called @#{loc.inspect}"

  return [loc] if grid_at(loc) == 'E'
  return (nil) if grid_at(loc) == '#'
  return (nil) if visited[loc]

  forward_loc = vadd(loc, dir)
  left_dir = turn_left(dir)
  left_loc = vadd(loc, left_dir)
  right_dir = turn_right(dir)
  right_loc = vadd(loc, right_dir)

  new_visited = visited.merge(loc => true)

  result =
    [
      shortest_maze_path(left_loc, left_dir, new_visited),
      shortest_maze_path(forward_loc, dir, new_visited),
      shortest_maze_path(right_loc, right_dir, new_visited)
    ].compact.min_by { |e| e.length }

  [loc, *result] unless result.nil?
end

print_grid
lms = lowest_maze_score_with_pruning(start_loc, [1, 0])
p lms
