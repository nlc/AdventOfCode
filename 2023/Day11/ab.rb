def get_empty_rows(grid)
  grid.filter_map.with_index do |row, irow|
    irow if row.none? { |char| char == '#' }
  end
end

def galaxy_distances(galaxies, empty_rows, empty_cols, expansion_factor)
  dist_sum = 0
  galaxies.length.times do |i|
    galaxy_i = galaxies[i]
    i.times do |j|
      galaxy_j = galaxies[j]

      xs = [galaxy_i[0], galaxy_j[0]].sort
      ys = [galaxy_i[1], galaxy_j[1]].sort

      horiz_base_dist = (xs.inject(&:-)).abs
      vert_base_dist = (ys.inject(&:-)).abs

      horiz_range = (xs.first..xs.last)
      vert_range = (ys.first..ys.last)

      horiz_empties_between = empty_cols.count { |icol| horiz_range.include?(icol) }
      vert_empties_between = empty_rows.count { |icol| vert_range.include?(icol) }

      dist_sum += horiz_base_dist + horiz_empties_between * (expansion_factor - 1)
      dist_sum += vert_base_dist + vert_empties_between * (expansion_factor - 1)
    end
  end

  dist_sum
end

def day11a(galaxies, empty_rows, empty_cols)
  galaxy_distances(galaxies, empty_rows, empty_cols, 2)
end

def day11b(galaxies, empty_rows, empty_cols)
  galaxy_distances(galaxies, empty_rows, empty_cols, 1000000)
end

fname = ARGV.shift || 'input.txt'

grid = File.readlines(fname, chomp: true).map(&:chars)

empty_rows = get_empty_rows(grid)
empty_cols = get_empty_rows(grid.transpose)

galaxies = []
grid.length.times do |y|
  grid[y].length.times do |x|
    if grid[y][x] == '#'
      galaxies << [x, y]
    end
  end
end

puts 'Day 11:'
puts "  Part A: #{day11a(galaxies, empty_rows, empty_cols)}"
puts "  Part B: #{day11b(galaxies, empty_rows, empty_cols)}"
