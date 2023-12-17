require 'set'

def vadd(a, b)
  a.zip(b).map { |ea, eb| ea + eb }
end

DIRECTIONS = {
  E: [ 1,  0],
  N: [ 0, -1],
  W: [-1,  0],
  S: [ 0,  1]
}

DEVICES ={
  '/' => DIRECTIONS.keys.zip([[:N], [:E], [:S], [:W]]).to_h,
  '\\' => DIRECTIONS.keys.zip([[:S], [:W], [:N], [:E]]).to_h,
  '-' => DIRECTIONS.keys.zip([[:E], [:E, :W], [:W], [:E, :W]]).to_h,
  '|' => DIRECTIONS.keys.zip([[:N, :S], [:N], [:N, :S], [:S]]).to_h,
  '.' => DIRECTIONS.keys.zip([[:E], [:N], [:W], [:S]]).to_h,
}

def in_grid?(point, grid)
  x, y = point

  x < grid.first.length && x >= 0 && y < grid.length && y >= 0
end

def propagate(light, grid)
  x, y, v = light

  x, y = vadd([x, y], DIRECTIONS[v])
  return [] unless in_grid?([x, y], grid)

  tile = grid[y][x]
  DEVICES[tile][v].filter_map do |direction|
    [x, y, direction]
  end
end

def propagate_all(lights, grid)
  seen_lights = Set.new(lights)
  visitation = Array.new(grid.length) { Array.new(grid.first.length) { 0 } }
  last_visitation_count = nil

  t = 0
  loop do
    t += 1
    any_moved = false

    lights.each do |x, y, v|
      visitation[y][x] += 1 if in_grid?([x, y], grid)
    end
    visitation_count = visitation.sum { |row| row.count { |visited| visited > 0 } }

    # break if visitation_count == last_visitation_count
    last_visitation_count = visitation_count

    lights =
      lights.map do |light|
        propagate(light, grid)
      end.flatten(1).reject do |light|
        seen_lights.include?(light)
      end

    lights.each do |light|
      seen_lights.add(light)
    end

    break if lights.empty?
  end

  last_visitation_count
end

fname = ARGV.shift || 'input.txt'
grid = File.readlines(fname, chomp: true).map(&:chars)

def day16a(grid)
  propagate_all([[-1, 0, :E]], grid)
end

def day16b(grid)
  edge_squares =
    grid.length.times.map do |y|
      [
        [-1, y, :E],
        [grid.first.length, y, :W]
      ]
    end \
    + \
    grid.first.length.times.map do |x|
      [
        [x, -1, :S],
        [x, grid.length, :N]
      ]
    end

  # edge_squares.flatten(1).map { |edge_square| [edge_square, propagate_all([edge_square], grid)] }.max_by { |edge_square, score| score } # Also shows winning path
  edge_squares.flatten(1).map { |edge_square| propagate_all([edge_square], grid) }.max
end

puts 'Day 16:'
puts "  Part A: #{day16a(grid)}"
puts "  Part B: #{day16b(grid)}"
