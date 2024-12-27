require_relative '../../utilities/utils.rb'

GRID = File.readlines('input.txt', chomp: true).map { |line| line.chars.map(&:to_i) }
GRID_BOUNDS = [[0, GRID.first.length], [0, GRID.length]]

NBR_VECS = [
  [ 1,  0],
  [ 0,  1],
  [-1,  0],
  [ 0, -1]
]

def grid_at(loc)
  x, y = loc

  GRID[y][x]
end

def locs_with_value(testval)
  locs = []

  GRID.each_with_index do |row, y|
    row.each_with_index do |val, x|
      locs << [x, y] if val == testval
    end
  end

  locs
end

def loc_nbrs(loc)
  NBR_VECS.map do |nbr_vec|
    vadd(loc, nbr_vec)
  end
end

def walkable_nbrs(loc)
  loc_height = grid_at(loc)

  loc_nbrs(loc).select do |nbr|
    vinbounds?(nbr, GRID_BOUNDS) && ((grid_at(nbr) - loc_height) == 1)
  end
end

def count_peak_paths(loc) # Ha, did this first by accident
  return 1 if grid_at(loc) == 9

  walkable_nbrs(loc).sum do |nbr|
    count_peak_paths(nbr)
  end
end

def recurse_reachable_peaks(loc)
  return [loc] if grid_at(loc) == 9

  walkable_nbrs(loc).map do |nbr|
    recurse_reachable_peaks(nbr)
  end
end

def reachable_peaks(loc)
  recurse_reachable_peaks(loc).flatten(9 - grid_at(loc)).uniq
end

def day10a
  locs_with_value(0).sum do |loc|
    reachable_peaks(loc).length
  end
end

def day10b
  locs_with_value(0).sum do |loc|
    count_peak_paths(loc)
  end
end

puts "Day 10:"
puts "  Part A: #{day10a}"
puts "  Part B: #{day10b}"
