require '../intcode.rb'
require '../../utilities/memo.rb'

def probe(intcode, x, y)
  intcode.reset

  intcode.execute
  intcode.execute(x)
  intcode.execute(y).first
end

def memo_probe(intcode, x, y)
  _memo(:probe, intcode, x, y)
end

# rectangular "snapshot" of values in x and y range
def snapshot(intcode, x, y, w, h)
  h.times.map do |j|
    w.times.map do |i|
      memo_probe(intcode, x + i, y + j)
    end
  end
end

def string_snapshot(intcode, x, y, w, h)
  snapshot(intcode, x, y, w, h).map do |line|
    line.map { |value| %w[. #][value] }.join
  end.join("\n")
end

def scan
  intcode = Intcode.new('input.txt')

  vx = 5
  vy = 10
  100.times do |i|
    x = i * vx
    y = i * vy
    pic = string_snapshot(intcode, x, y, 100, 50)
    print "\033[2J\033[H"
    print pic
    print "[TL x=#{x} y=#{y}]"

    sleep 1
  end
end

# Get start and width of each row
def rows(max_width = 200)
  intcode = Intcode.new('input.txt')

  row_start = 0
  row_width = 0

  last_row_start = 0
  last_row_width = 0

  y = 10 # avoid early missing entries

  row_info = {}

  while row_width < max_width
    puts y

    x = last_row_start

    occupied = 0
    until occupied == 1 # first, walk to the first filled square
      occupied = probe(intcode, x, y)
      x += 1
    end
    last_row_start = row_start = x - 1

    x = row_start + last_row_width

    until occupied == 0
      occupied = probe(intcode, x, y)
      x += 1
    end
    row_finish = x - 1

    row_width = row_finish - row_start

    p row_info[y] = [row_start, row_width]

    y += 1
  end

  row_info
end

#all rows data
def write_all_rows_data(max_width)
  all_rows_data = rows(max_width)

  File.open("all_rows_data_w#{max_width}.txt", 'w') do |file|
    all_rows_data.each do |k, v|
      file.puts "#{k} #{v.join("\t")}"
    end
  end
end

$all_rows_data =
  File.readlines('all_rows_data_w250.txt').map do |line|
    y, start, length = line.match(/(\d+) (\d+) (\d+)/).to_a.drop(1).map(&:to_i)

    [y, start..(start + length - 1)]
  end.to_h

def in?(x, y)
  $all_rows_data[y]&.include?(x) || false
end

square_size = 100
offset = square_size - 1

bottom_left_corner =
  $all_rows_data.to_a.find do |y, range|
    x = range.begin
    in?(x + offset, y - offset)
  end

puts bottom_left_corner[1].begin * 10000 + (bottom_left_corner[0] - offset)
