def get_elf_points(fname)
  elf_points = {}

  File.readlines(fname, chomp: true).reverse.each_with_index do |row, y|
    row.chars.each_with_index do |char, x|
      if char == '#'
        elf_points[[x, y]] = true
      end
    end
  end

  elf_points
end

DIRECTIONS = %w(N NE E SE S SW W NW)
NEIGHBORHOOD = [
  [ 0,  1],
  [ 1,  1],
  [ 1,  0],
  [ 1, -1],
  [ 0, -1],
  [-1, -1],
  [-1,  0],
  [-1,  1]
]
def neighbors_of_point(point)
  x, y = point

  DIRECTIONS.zip(NEIGHBORHOOD.map { |dx, dy| [x + dx, y + dy] }).to_h
end

STARTING_DIRECTIONS_TO_CONSIDER = {
  'N' => %w(N NE NW),
  'S' => %w(S SE SW),
  'W' => %w(W NW SW),
  'E' => %w(E NE SE)
}
def generate_proposals(elf_points, directions_to_consider)
  elf_points.map do |elf_point, _|
    neighboring_points = neighbors_of_point(elf_point)
    neighboring_elves = neighboring_points.select{ |direction, neighboring_point| elf_points[neighboring_point] }
    neighboring_elf_directions = neighboring_elves.keys

    directions_to_consider.lazy.filter_map do |direction, to_consider|
      if (to_consider & neighboring_elf_directions).empty?
        neighboring_points[direction]
      end
    end.first
  end
end

def move_elves(elf_points, directions_to_consider)
  proposals = generate_proposals(elf_points, directions_to_consider)


end

def day23a(fname)
  10.times do
    elf_points = move_elves(elf_points, directions_to_consider)
  end
end

fname = ARGV.shift || 'input.txt'
