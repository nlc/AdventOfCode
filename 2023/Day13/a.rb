fname = ARGV.shift || 'input.txt'

def line_symmetry(line)
  # index of space *to the right* of the nth char
  (line.length - 1).times.select do |starting_point|
    [(starting_point + 1), line.length - starting_point - 1].min.times.all? do |i|
      l = starting_point - i
      r = starting_point + i + 1

      line[l] == line[r]
    end
  end
end

def rect_symmetry(rect)
  rect.map do |line|
    line_symmetry(line)
  end.reduce(&:&).map(&:succ)
end

def two_way_symmetry(rect)
  horiz = rect_symmetry(rect)
  vert = rect_symmetry(rect.transpose)

  raise 'no symmetry!' unless (horiz.any? || vert.any?)

  # [100 * horiz.first, vert.first]
  (horiz.first || 0) + 100 * (vert.first || 0)
end

patterns = File.read(fname, chomp: true).split("\n\n").map do |pattern_str|
  pattern_str.split("\n").map(&:chars)
end

summary =
  patterns.sum do |pattern|
    two_way_symmetry(pattern)
  end

p summary
