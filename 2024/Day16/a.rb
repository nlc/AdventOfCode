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

GRID = File.readlines('sample.txt', chomp: true).map(&:chars)

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
  puts "called @#{loc.inspect}"

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
    1000 + lowest_maze_score(left_loc, left_dir, new_visited),
    1 + lowest_maze_score(forward_loc, dir, new_visited),
    1000 + lowest_maze_score(right_loc, right_dir, new_visited)
  ].min
end

print_grid
p lowest_maze_score(start_loc, [1, 0])
