require 'set'

require_relative '../../utilities/utils.rb'

def first_unused_cell(used_cells)
  # the dumb way
  GRID.each_with_index do |line, y|
    line.length.times do |x|
      return [x, y] unless used_cells.include?([x, y])
    end
  end

  return nil
end

DIRS = [
  [ 1,  0],
  [ 0,  1],
  [-1,  0],
  [ 0, -1]
]

def flood_fill(loc, used_cells)
  used_cells.add(loc)

  DIRS.each do |dir|
    nbr = vadd(loc, dir)

    if vinbounds?(nbr, GRID_BOUNDS) && (GRID[nbr[1]][nbr[0]] == GRID[loc[1]][loc[0]]) && (!used_cells.include?(nbr))
      flood_fill(nbr, used_cells)
    end
  end

  used_cells
end

def plot_perimeter(plot)
  plot.sum do |loc|
    DIRS.sum do |dir|
      nbr = vadd(loc, dir)

      plot.include?(nbr) ? 0 : 1
    end
  end
end

GRID = File.readlines('input.txt', chomp: true).map(&:chars)
GRID_BOUNDS = [[0, GRID.first.length], [0, GRID.length]]
TOTAL_CELLS = GRID.length * GRID.first.length

plots = {}
all_used_cells = Set.new

loc = nil
while loc = first_unused_cell(all_used_cells)
  plots[loc] = Set.new
  flood_fill(loc, plots[loc])

  all_used_cells += plots[loc]
end

result =
  plots.sum do |_, plot|
    # print "#{plot.length} * #{plot_perimeter(plot)} = "
    # p plot.length * plot_perimeter(plot)
    plot.length * plot_perimeter(plot)
  end

puts result
