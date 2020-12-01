require_relative '../intcode.rb'

intcode = Intcode.new('input.txt', true)
intcode.setmemory(0, 2)

gridw = 40
gridh = 22
grid = Array.new(gridh){Array.new(gridw){0}}

score = 0

ballx = nil
paddlex = nil

while intcode.running?
  30.times do
    puts
  end

  instruction =
    if ballx && paddlex
      ballx <=> paddlex
    else
      nil
    end

  intcode.execute(instruction).each_slice(3) do |x, y, t|
    if x == -1 && y == 0
      score = t
    else 
      grid[y][x] = t
    end
  end

  grid.each do |row|
    row.each_with_index do |tilenum, i|
      if tilenum == 3
        paddlex = i
      elsif tilenum == 4
        ballx = i
      end
    end.join('')
  end

  # sleep 0.05
end
