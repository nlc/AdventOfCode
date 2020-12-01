require_relative 'intcode.rb'

grid_side = 256

grid = Array.new(grid_side){Array.new(grid_side){0}}
visited = {}
robot_x = grid_side / 2
robot_y = grid_side / 2
robot_heading = :N

intcode = Intcode.new('input.txt', true)

while intcode.running?
  visited[ [robot_x, robot_y] ] = true

  color, turn = intcode.execute(grid[robot_y][robot_x])

  unless color && turn
    puts "done"
    break
  end

  grid[robot_y][robot_x] = color

  robot_heading =
    case turn
    when 1
      { N: :E, E: :S, S: :W, W: :N }[robot_heading]
    when 0
      { N: :W, W: :S, S: :E, E: :N }[robot_heading]
    else
      raise "illegal turn instruction #{turn}"
    end

  case robot_heading
  when :N
    robot_y -= 1
  when :E
    robot_x += 1
  when :S
    robot_y += 1
  when :W
    robot_x -= 1
  else
    raise "illegal heading #{robot_heading}"
  end
end

puts visited.length
