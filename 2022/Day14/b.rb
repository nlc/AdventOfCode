fname = ARGV.shift || 'input.txt'
input = File.readlines(fname)

AIR = 0
ROCK = 1
SAND = 2

$grid = Array.new(1000) { Array.new(1000) { AIR } }

$min_x = Float::INFINITY
$min_y = Float::INFINITY
$max_x = -Float::INFINITY
$max_y = -Float::INFINITY

input.each do |record|
  endpoints = record.split(/ -> /).map { |endpoint_str| endpoint_str.split(/,/).map(&:to_i) }

  endpoints.each_cons(2) do |coord1, coord2|

    # Yuck
    if coord1[0] < $min_x
      $min_x = coord1[0]
    end
    if coord1[0] > $max_x
      $max_x = coord1[0]
    end
    if coord1[1] < $min_y
      $min_y = coord1[1]
    end
    if coord1[1] > $max_y
      $max_y = coord1[1]
    end
    if coord2[0] < $min_x
      $min_x = coord2[0]
    end
    if coord2[0] > $max_x
      $max_x = coord2[0]
    end
    if coord2[1] < $min_y
      $min_y = coord2[1]
    end
    if coord2[1] > $max_y
      $max_y = coord2[1]
    end

    if coord1[0] != coord2[0] # difference in x
      raise 'oops' if coord1[1] != coord2[1]

      y = coord1[1]
      x_start, x_end = [coord1[0], coord2[0]].sort

      (x_start..x_end).each do |x|
        $grid[y][x] = ROCK
      end
    elsif coord1[1] != coord2[1] # difference in y
      raise 'oops' if coord1[0] != coord2[0]

      x = coord1[0]
      y_start, y_end = [coord1[1], coord2[1]].sort

      (y_start..y_end).each do |y|
        $grid[y][x] = ROCK
      end
    end
  end
end

def sand_fall
  x = 500
  y = 0

  while true
    down = $grid[y + 1][x]
    down_left = $grid[y + 1][x - 1]
    down_right = $grid[y + 1][x + 1]

    break if [down, down_left, down_right].any?(&:nil?)

    if y >= $max_y + 1
      $grid[y][x] = SAND
      return true
    end

    if down == AIR
      y = y + 1
    elsif down_left == AIR
      x = x - 1
      y = y + 1
    elsif down_right == AIR
      x = x + 1
      y = y + 1
    else
      $grid[y][x] = SAND
      return true
    end
  end
end

sand_fall

sand_count = 1 # TODO: investigate why this isn't 0
while $grid[0][500] == AIR
  sand_fall

  sand_count += 1
end

# puts $grid[0..($max_y + 2)].map{|row|row[($min_x - 2)..($max_x + 2)].map{|square|' #.'.chars[square]}.join('')}.join("\n")

puts sand_count
