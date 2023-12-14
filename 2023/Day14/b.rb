require 'pp'
require 'set'

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


def roll(direction, grid, spheres)
  no_change = false
  until no_change
    no_change = true

    spheres.length.times do |isphere|
      sphere = spheres[isphere]
      x, y = neighbor = vadd(sphere, direction)
      next if (x >= grid.first.length) || (x < 0) || (y >= grid.length) || (y < 0)

      if grid[y][x] == '.'
        spheres[isphere] = neighbor

        grid[y][x] = 'O'
        grid[sphere[1]][sphere[0]] = '.'

        no_change = false
      end
    end
  end
end

def cycle(grid, spheres)
  [
    [ 0, -1],
    [-1,  0],
    [ 0,  1],
    [ 1,  0],
  ].each do |direction|
    roll(direction, grid, spheres)
  end
end

grid_hashes = { grid.hash => 0 }

cycle_length = nil
cycle_offset = nil
t = 0
loop do
  t += 1

  cycle(grid, spheres)
  grid_hash = grid.hash

  if grid_hashes.key?(grid_hash)
    cycle_offset = grid_hashes[grid_hash]
    cycle_length = t - cycle_offset

    puts "First recurrence occurs at t=#{t}, referring to t=#{grid_hashes[grid_hash]}"
    puts "cycle_length=#{cycle_length}, cycle_offset=#{cycle_offset}"
    break
  end

  grid_hashes[grid_hash] = t

  # puts grid.map(&:join).join("\n")
end

long_term_steps = 1000000000 - cycle_offset
steps_to_go = long_term_steps % cycle_length

puts "#{long_term_steps} % #{cycle_length} = #{steps_to_go}"

steps_to_go.times do
  cycle(grid, spheres)
end

summation =
  spheres.sum do |sphere|
    height - sphere[1]
  end

p summation
