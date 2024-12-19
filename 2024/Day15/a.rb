require 'set'

require_relative '../../utilities/utils.rb'

def grid_at(loc, grid)
  x, y = loc

  grid[y][x]
end

def print_grid(grid)
  grid.each do |line|
    puts line.join
  end
end

def push!(loc, dir, grid)
  char = grid_at(loc, grid)
  next_loc = vadd(loc, dir)

  case char
  when '.'
    true
  when /[O@]/
    if push!(next_loc, dir, grid) # then swap
      next_char = grid_at(next_loc, grid)
      grid[next_loc[1]][next_loc[0]] = char
      grid[loc[1]][loc[0]] = next_char

      true
    end
  when '#'
    false
  else
    raise "Reached the end of the line! Char = #{char.inspect}"
  end
end

def sum_gps(grid)
  mysum = 0
  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      mysum +=
        if char == 'O'
          100 * y + x
        else
          0
        end
    end
  end

  mysum
end

grid_str, instructions_str = File.read('input.txt').split(/\n\n/)

instructions = instructions_str.gsub(/\n/, '').chars

grid =
  grid_str.split(/\n/).map do |line|
    line.chars
  end

robot_loc = nil

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == '@'
      robot_loc = [x, y]
    end
  end
end

instruction_to_dir = {
  '>' => [1, 0],
  '^' => [0, -1],
  '<' => [-1, 0],
  'v' => [0, 1]
}

instructions.each do |instruction|
  dir = instruction_to_dir[instruction]

  robot_loc = vadd(robot_loc, dir) if push!(robot_loc, dir, grid)
end

# print_grid(grid)
p sum_gps(grid)
