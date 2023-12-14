# It's not respecting finding a very obvious-looking vertical solution in the very first one (last two lines)
# Is there a problem with how it checks for symmetry when it's near an edge?

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

  return nil unless (horiz.any? || vert.any?)

  [horiz.first, vert.first]
  # (horiz.first || 0) + 100 * (vert.first || 0)
end

def smudge(rect)
  p original_symmetry = two_way_symmetry(rect)

  rect.length.times do |y|
    rect[y].length.times do |x|
      puts "smudging #{[x, y].inspect}"
      original = rect[y][x]
      rect[y][x] = original == '.' ? '#' : '.'
      puts rect.map(&:join).join("\n")

      p curr_symmetry = two_way_symmetry(rect)
      unless curr_symmetry.nil?
        horiz, vert = curr_symmetry.zip(original_symmetry).map { |curr, orig| curr unless orig == curr }
        return (horiz || 0) + (vert || 0) * 100 unless !(horiz || vert)
      end

      rect[y][x] = original
    end
  end

  # puts rect.map(&:join).join("\n")
  raise 'bad assumption!'
end

# patterns = File.read(fname, chomp: true).split("\n\n").map do |pattern_str|
#   pattern_str.split("\n").map(&:chars)
# end
# 
# summary =
#   patterns.map.with_index do |pattern, i|
#     p i
#     smudge(pattern)
#   end.sum
# 
# p summary

# summary =
#   patterns.sum do |pattern|
#     two_way_symmetry(pattern)
#   end
# 
# p summary
