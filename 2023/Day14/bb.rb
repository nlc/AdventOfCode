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

  grid
end

# input: [ single_state, target_number, { mutation_block } ]
# output: [ short_term_behavior_length, long_term_behavior_start, cycle_length, steps_until_target_modulo_cycle_length ]
def cyclic_mutate(state, target_number)
  state_hashes = { state.hash => 0 }
  cycle_offset = nil
  cycle_length = nil
  long_term_steps = nil
  steps_to_go = nil

  target_number.times do |t|
    t += 1
    state = yield t

    state_hash = state.hash
    if state_hashes.key?(state_hash)
      cycle_offset = state_hashes[state_hash]
      cycle_length = t - cycle_offset
      long_term_steps = target_number - cycle_offset
      steps_to_go = long_term_steps % cycle_length

      break
    else
      state_hashes[state_hash] = t
    end
  end

  [cycle_offset, cycle_length, steps_to_go]
end

cycle_data =
  cyclic_mutate(grid, 1000000000) do
    grid = cycle(grid, spheres)
  end

cycle_offset, cycle_length, steps_to_go = cycle_data

steps_to_go.times do
  cycle(grid, spheres)
end

summation =
  spheres.sum do |sphere|
    height - sphere[1]
  end

p summation
