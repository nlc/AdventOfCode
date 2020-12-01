require 'io/console'

require_relative '../intcode.rb'

tiles = {
  -1 => ' ', # unknown
  0 => '.',  # open
  1 => '#',  # wall
  2 => 'X'   # target
}

statuses = {
  0 => 'blocked',
  1 => 'moved',
  2 => 'found'
}

directions = {
  1 => 'N',
  2 => 'S',
  3 => 'W',
  4 => 'E'
}

oppdir = {
  'N' => 'S',
  'S' => 'N',
  'E' => 'W',
  'W' => 'E'
}

display = false

gridside = 128
grid = Array.new(gridside){Array.new(gridside){-1}}

intcode = Intcode.new('input.txt')
intcode.execute # looks like it needs to do some preprocessing

robotx = gridside / 2
roboty = gridside / 2
camefrom = nil

targetloc = nil

exits = {}

# dfs stack
pathstack = []

while !targetloc do
  # move

  # # random walk
  # dirnum = rand(4) + 1

  # # user input
  # dirnum = {'k' => 1, 'j' => 2, 'h' => 3, 'l' => 4}[STDIN.getch]

  unless exits[ [robotx, roboty] ]
    exits[ [robotx, roboty] ] = {}
  end

  # dfs
  nextexit =
    directions.find do |key, value|
      !(exits[ [robotx, roboty] ].key? value)
    end

  if nextexit.nil?
    nextexit =
      directions.find do |key, value|
        value != camefrom && exits[ [robotx, roboty] ][value] == true
      end
  end

  if nextexit.nil?
    nextexit =
      directions.find do |key, value|
        exits[ [robotx, roboty] ][value] == true
      end
  end

  dirnum = nextexit.first

  dir = directions[dirnum]
  resp = intcode.execute(dirnum).first
  case statuses[resp]
  when 'blocked'
    exits[ [robotx, roboty] ][dir] = false

    case dir
    when 'N'
      grid[roboty - 1][robotx] = 1
    when 'W'
      grid[roboty][robotx - 1] = 1
    when 'S'
      grid[roboty + 1][robotx] = 1
    when 'E'
      grid[roboty][robotx + 1] = 1
    end
  when 'moved'
    exits[ [robotx, roboty] ][dir] = true

    case dir
    when 'N'
      grid[roboty - 1][robotx] = 0
      roboty -= 1
    when 'W'
      grid[roboty][robotx - 1] = 0
      robotx -= 1
    when 'S'
      grid[roboty + 1][robotx] = 0
      roboty += 1
    when 'E'
      grid[roboty][robotx + 1] = 0
      robotx += 1
    end

    pathstack << dir

    camefrom = oppdir[dir]
  when 'found'
    exits[ [robotx, roboty] ][dir] = true

    case dir
    when 'N'
      grid[roboty - 1][robotx] = 2
      roboty -= 1
    when 'W'
      grid[roboty][robotx - 1] = 2
      robotx -= 1
    when 'S'
      grid[roboty + 1][robotx] = 2
      roboty += 1
    when 'E'
      grid[roboty][robotx + 1] = 2
      robotx += 1
    end

    pathstack << dir

    camefrom = oppdir[dir]
    targetloc = [robotx, roboty]
  else
    raise "illegal response #{resp}"
  end

  # display
  if display
    grid.each_with_index do |row, y|
      rowstr =
        row.map.with_index do |tile, x|
          if x == robotx && y == roboty
            'D'
          else
            tiles[tile]
          end
        end.join('')
      puts rowstr
    end
    sleep 0.2
  end

  p pathstack
end

p targetloc
