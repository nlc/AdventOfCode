require_relative '../intcode.rb'

intcode = Intcode.new('input.txt')

grid = intcode.execute.map{|x|x.chr}.join('').split(/\n/).map(&:chars)

# crude but effective
intersections = []
grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    if char == '#'
      intersect =
        [[1, 0], [0, 1], [-1, 0], [0, -1]].all? do |dx, dy|

          grid[y + dy] && grid[y + dy][x + dx] == '#'
        end
      if intersect
        intersections << x * y
      end
    end
  end
end

p intersections.inject(:+)
