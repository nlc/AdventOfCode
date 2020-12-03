def toboggan(grid, change)
  pointer = [0, 0]; # x, y
  trees = []
  blanks = []
  while pointer[1] < grid.length
    case grid[pointer[1]][pointer[0]]
    when '#'
      trees << pointer.clone
    when '.'
      blanks << pointer.clone
    else
      raise 'out of bounds'
    end

    pointer[0] = (pointer[0] + change[0]) % grid[0].length
    pointer[1] += change[1]
  end

  trees.length
end

grid = File.readlines('input.txt', chomp: true)

# Part A
parta = toboggan(grid, [3,1])

# Part B
partb =
  [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map do |change|
    toboggan(grid, change)
  end.inject(:*)

puts "Part A: #{parta}"
puts "Part B: #{partb}"
