require_relative '../../utilities/utils.rb'

class Walker < WalkerBase
  attr_accessor :grid, :visited

  def initialize(grid)
    @grid = grid
    @visited = {}

    x = nil
    y = nil
    @grid.each.with_index do |line, j|
      if (x ||= line.index('^'))
        y = j
        break
      end
    end

    super(x, y, :N)
  end

  def walk(distance=1) # Walk forward
    case @d
    when :E
      @x += distance
    when :N
      @y -= distance
    when :W
      @x -= distance
    when :S
      @y += distance
    end
  end

  def in_grid?
    x >= 0 && x < @grid.first.length && y >= 0 && y < @grid.length
  end

  def visit_current
    @visited[[x, y]] ||= 0

    @visited[[x, y]] += 1
  end

  def step_until_blocked
    while in_grid? && grid[y][x] != '#' && @visited[[x, y]] != d
      visit_current
      walk
    end

    if in_grid? && grid[y][x] == '#'
      step(:B)
      turn(:R)
    end
  end

  def guard_routine
    while in_grid? && (@visited[[x, y]].nil? || @visited[[x, y]] < 3)
      step_until_blocked
    end

    return (!@visited[[x, y]].nil?) && @visited[[x, y]] >= 3 # whether it's a loop
  end
end

def day06a(grid)
  walker = Walker.new(grid)
  walker.guard_routine

  walker.visited.keys.length
end

def day06b(grid)
  sum = 0

  grid.each_with_index do |line, j|
    line.chars.each_with_index do |char, i|
      if char == '.'
        grid[j][i] = '#'

        walker = Walker.new(grid)
        if walker.guard_routine
          sum += 1
        end

        grid[j][i] = '.'
      end
    end
  end

  sum
end

grid = File.readlines('input.txt')

puts "Day 06"
puts "  Part A: #{day06a(grid)}"
puts "  Part B: #{day06b(grid)}"
