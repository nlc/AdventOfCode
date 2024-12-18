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

robots = File.readlines('input.txt').map { |line| line.scan(/-?\d+/).map(&:to_i) }

(101 * 103).times do |t|
  puts t if t % 100 == 0

  draw_grid(gen_grid(robots), 'frame_%05d.pbm' % t)

  robots = advance_robots(robots)
end
