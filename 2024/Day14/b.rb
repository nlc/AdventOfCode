require 'pp'

def draw_grid(grid, fname)
  File.open(fname, 'w') do |file|
    file.puts 'P1'
    file.puts "# #{fname}"
    file.puts "#{grid.first.length} #{grid.length}"

    grid.each do |line|
      line.each do |char|
        file.print char
        file.print ' '
      end
      file.puts
    end
  end
end

def advance_robots(robots)
  robots.map do |x, y, vx, vy|
    [(x + vx) % 101, (y + vy) % 103, vx, vy]
  end
end

def gen_grid(robots)
  grid = Array.new(103) { Array.new(101) { 0 } }

  robots.each do |x, y, _, _|
    grid[y][x] = 1
  end

  grid
end

# Measure how "neighbory" a grid is; rough measure of how likely it is to contain a picture
def grid_x_neighborness(grid)
  height = grid.length
  width = grid.first.length
  height.times.sum do |y|
    (width - 1).times.sum do |x|
      grid[y][x] * grid[y][x + 1]
    end
  end
end

robots = File.readlines('input.txt').map { |line| line.scan(/-?\d+/).map(&:to_i) }

sum_neighborness = 0
max_neighborness = 0
max_neighborness_grids = {}

num_frames = 101 * 103

num_frames.times do |t|
  # puts t if t % 100 == 0
  # draw_grid(gen_grid(robots), 'frame_%05d.pbm' % t)

  grid = gen_grid(robots)
  neighborness = grid_x_neighborness(grid)
  sum_neighborness += neighborness
  if neighborness > max_neighborness
    max_neighborness_grids[t] = [grid, neighborness]
    max_neighborness = neighborness
  end

  robots = advance_robots(robots)
end

avg_neighborness = sum_neighborness / num_frames

puts 'Candidate Frames:'
max_neighborness_grids.each do |t, (grid, neighborness)| # very unscientific
  if neighborness > avg_neighborness
    printf("  %05d: n=%d\n", t, neighborness)
    draw_grid(grid, 'candidate_%05d.pbm' % t)
  end
end
