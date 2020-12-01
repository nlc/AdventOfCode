require_relative '../intcode.rb'

tiles = {
  0 => ' ',      # empty
  1 => "\u2592", # wall
  2 => "\u2589", # block
  3 => "\u2594", # paddle
  4 => "\u25cb"  # ball
}

intcode = Intcode.new('input.txt', false)
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
    vis =
      row.map.with_index do |tilenum, i|
        tile = tiles[tilenum]
        if tilenum == 3
          paddlex = i
        elsif tilenum == 4
          ballx = i
        end
        tile
      end.join('')
    puts vis
  end

  puts '               [ %05d ]' % score
  sleep 0.05
end
