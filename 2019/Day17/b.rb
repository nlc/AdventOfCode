require_relative '../intcode.rb'

def addvec(a, b)
  a.zip(b).map{|ai, bi| ai + bi}
end

# direction <-> vector
d2v = {
  'E' => [1, 0],
  'N' => [0, 1],
  'W' => [-1, 0],
  'S' => [0, -1]
}
v2d = d2v.invert

# arrow -> direction
a2d = {
  '>' => 'E',
  '^' => 'N',
  '<' => 'W',
  'v' => 'S'
}

# direction, direction -> turn
dd2t = {
  ['E', 'N'] => 'L',
  ['N', 'W'] => 'L',
  ['W', 'S'] => 'L',
  ['S', 'E'] => 'L',

  ['E', 'S'] => 'R',
  ['S', 'W'] => 'R',
  ['W', 'N'] => 'R',
  ['N', 'E'] => 'R',
}

# direction -> opposite direction
od = {
  'E' => 'W',
  'N' => 'S',
  'W' => 'E',
  'S' => 'N'
}

intcode = Intcode.new('input.txt')
intcode.setmemory(0, 2)

grid = intcode.execute.map{|x|x.chr}.join('').split(/\n/).map(&:chars)
robotloc = nil
robotdir = nil

# crude but effective
outlets = {}
grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    if (char == '#' || %w{> ^ < v}.include?(char)) && !(outlets.key? [x, y])
      if %w{> ^ < v}.include? char
        robotloc = [x, y]
        robotdir = a2d[char]
      end
      outlets[ [x, y] ] = []
      [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dx, dy|
        if grid[y + dy] && grid[y + dy][x + dx] == '#'
          outlets[ [x, y] ] << v2d[ [dx, dy] ]
        end
      end
    end
  end
end

recording = []
def record(str, recording)
  # puts str # for now
  if (str.to_i == 1) && (recording.length > 0) && (recording.last.to_i != 0)
    recording[-1] = recording[-1].to_i + 1
  elsif !recording.empty?
    recording << ','
    recording << str
  else
    recording << str
  end
end

# traverse the "scaffold," only turning when absolutely necessary

# start by aligning properly
# options = outlets[robotloc]
# record(dd2t[[robotdir, options.first]], recording)

# loop until done
loop do
  options = outlets[robotloc] - [ od[robotdir] ]
  # if there is "straight" option then proceed
  if options.include? robotdir
    record(1, recording)
    robotloc = addvec(robotloc, d2v[robotdir])
  elsif options.length == 1 # if not then turn
    turn = dd2t[ [robotdir, options.first] ]
    record(turn, recording)
    robotdir = options.first
  else
    break
  end
end

puts recording.join('')
