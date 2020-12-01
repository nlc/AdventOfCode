require_relative '../intcode.rb'

tiles = {
  0 => '.',
  1 => 'W',
  2 => 'B',
  3 => 'P',
  4 => '*'
}

intcode = Intcode.new('input.txt', false)

gridside = 40
grid = Array.new(gridside){Array.new(gridside){0}}

# p intcode.execute
# exit

intcode.execute.each_slice(3) do |x, y, t|
  grid[y][x] = t
end

ntiles = 0
grid.each do |row|
  vis =
    row.map do |tilenum|
      tile = tiles[tilenum]
      if tile == 'B'
        ntiles += 1
      end
      tile
    end.join('')
  puts vis
end

puts ntiles
