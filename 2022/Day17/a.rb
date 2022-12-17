OMINO_SPRITES = [
  [[2, 2, 2, 2]],

  [[0, 1, 0],
   [2, 1, 2],
   [0, 2, 0]],

  [[0, 0, 1],
   [0, 0, 1],
   [2, 2, 2]],

  [[1],
   [1],
   [1],
   [2]],

  [[1, 1],
   [2, 2]]
]

OMINO_POINTS = []
OMINO_IMPACT_POINTS = []
OMINO_WIDTHS = []
OMINO_HEIGHTS = []

OMINO_SPRITES.each_with_index do |omino_sprite, type|
  OMINO_WIDTHS << omino_sprite.map(&:length).max
  OMINO_HEIGHTS << omino_sprite.length

  OMINO_POINTS[type] = []
  OMINO_IMPACT_POINTS[type] = []
  omino_sprite.reverse.each_with_index do |row, y|
    row.each_with_index do |num, x|
      if num > 0
        OMINO_POINTS[type] << [x, y]

        if num == 2
          OMINO_IMPACT_POINTS[type] << [x, y]
        end
      end
    end
  end
end

def add(v1, v2)
  v1.zip(v2).map(&:sum)
end

class Omino
  attr_accessor :type, :x, :y, :width, :height

  def initialize(type, x, y)
    @type = type
    @x = x
    @y = y

    @width = OMINO_WIDTHS[@type]
    @height = OMINO_HEIGHTS[@type]
  end

  def leftmost
    @x
  end

  def rightmost
    @x + @width - 1
  end

  def highest
    @y + @height - 1
  end

  def lowest
    @y
  end

  def points
    OMINO_POINTS[@type].map do |offset|
      add([@x, @y], offset)
    end
  end

  def impact_points
    OMINO_IMPACT_POINTS[@type].map do |offset|
      add([@x, @y], offset)
    end
  end

  def test_points
    impact_points.map do |impact_point|
      add(impact_point, [0, -1])
    end
  end
end

class Board
  attr_accessor :width, :fallen_ominoes, :occupied_spaces

  def initialize(width)
    @width = width
    @fallen_ominoes = []
    @occupied_spaces = {}
  end

  def leftmost
    0
  end

  def rightmost
    @width - 1
  end

  def occupied?(point)
    occupied_spaces.key?(point)
  end

  def land(omino)
    omino.points.each do |point|
      @occupied_spaces[point] = true
    end

    @fallen_ominoes << omino
  end
end

def blow_around(omino, board, direction)
  p direction
  case direction
  when :LEFT
    if omino.leftmost > board.leftmost
      omino.x -= 1
    end
  when :RIGHT
    if omino.rightmost < board.rightmost
      omino.x += 1
    end
  end
end

def fall_one(omino, board, direction)
  # first, gets blown around:
  blow_around(omino, board, direction)

  # then: falls/lands:
  landing =
    omino.test_points.any? do |test_point|
      test_point[1] <= 0 || board.occupied?(test_point)
    end

  puts "landing when y=#{omino.y}" if landing

  unless landing
    omino.y -= 1
  end

  landing
end

def fall(omino, board, directions, directions_index)
  landing = false

  until landing do
    landing = fall_one(omino, board, directions[directions_index])

    directions_index += 1
    puts "#{omino.x},#{omino.y}"
  end

  # blow_around(omino, board, directions[directions_index])
  # directions_index += 1

  board.land(omino)

  directions_index
end

def print_board(board, width, height)
  (1..height).to_a.reverse.each do |y|
    (0..width).each do |x|
      print board.occupied?([x, y]) ? '#' : '.'
    end
    puts
  end
end

infile = ARGV.shift || 'input.txt'
directions = File.read(infile).chomp.chars.map { |char| {'<' => :LEFT, '>' => :RIGHT}[char] || (raise "illegal char #{char.inspect}") }

board = Board.new(7)

directions_index = 0
omino = Omino.new(0, 2, 4)
directions_index = fall(omino, board, directions, directions_index)
puts "#{omino.x},#{omino.y}"
puts '---------------'

omino = Omino.new(1, 2, 5)
directions_index = fall(omino, board, directions, directions_index)
puts "#{omino.x},#{omino.y}"

print_board(board, 7, 10)
