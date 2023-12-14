require 'pp'

def vadd(a, b)
  a.zip(b).map { |ea, eb| ea + eb }
end

fname = ARGV.shift || 'input.txt'

grid = File.readlines(fname, chomp: true).map(&:chars)

width = grid.first.length
height = grid.length

spheres = []
cubes = []

grid.each.with_index do |line, y|
  line.each.with_index do |char, x|
    point = [x, y]

    case char
    when 'O'
      spheres << point
    when '#'
      cubes << point
    end
  end
end


northward = [0, -1]

no_change = false
until no_change
  no_change = true

  spheres.length.times do |isphere|
    sphere = spheres[isphere]
    north_square = vadd(sphere, northward)
    next if north_square[1] < 0

    if grid[north_square[1]][north_square[0]] == '.'
      spheres[isphere] = north_square

      grid[north_square[1]][north_square[0]] = 'O'
      grid[sphere[1]][sphere[0]] = '.'

      no_change = false
    end
  end
end

summation =
  spheres.sum do |sphere|
    height - sphere[1]
  end

p summation
