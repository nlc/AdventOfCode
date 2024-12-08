def vsubtract(a1, a2)
  a1.zip(a2).map { |e1, e2| e1 - e2 }
end

def vadd(a1, a2)
  a1.zip(a2).map { |e1, e2| e1 + e2 }
end

def vnegative(a)
  a.map(&:-@)
end

def vinbounds?(a, bounds)
  a.zip(bounds).all? do |e, dim|
    dimmin, dimmax = dim

    e >= dimmin && e < dimmax
  end
end

def each_pairing(arr, no_self: false, &block)
  arr.length.times do |ei|
    (ei + (no_self ? 0 : 1)).times do |ej|
      block.call(arr[ei], arr[ej])
    end
  end
end

INPUT_FNAME = ARGV.shift || 'input.txt'

grid = File.readlines(INPUT_FNAME, chomp: true).map(&:chars)
grid_bounds = [[0, grid.length], [0, grid.first.length]]

antennae_by_type = {}

grid.each_with_index do |line, j|
  line.each_with_index do |char, i|
    unless char == '.'
      loc = [i, j]

      antennae_by_type[char] = [] unless antennae_by_type.key?(char)
      antennae_by_type[char] << loc
    end
  end
end

def day08a(antennae_by_type, grid_bounds)
  antinode_points = {}
  antennae_by_type.keys.each do |type|
    each_pairing(antennae_by_type[type], no_self: true) do |a, b|
      diff = vsubtract(b, a)

      antinode1 = vadd(b, diff)
      antinode2 = vsubtract(a, diff)
      antinode_points[antinode1] = true if vinbounds?(antinode1, grid_bounds)
      antinode_points[antinode2] = true if vinbounds?(antinode2, grid_bounds)
    end
  end

  antinode_points.length
end

def day08b(antennae_by_type, grid_bounds)
  antinode_points = {}
  antennae_by_type.keys.each do |type|
    each_pairing(antennae_by_type[type], no_self: true) do |a, b|
      diff = vsubtract(b, a)

      loc = a
      while vinbounds?(loc, grid_bounds)
        antinode_points[loc] = true
        loc = vsubtract(loc, diff)
      end

      loc = a
      while vinbounds?(loc, grid_bounds)
        antinode_points[loc] = true
        loc = vadd(loc, diff)
      end
    end
  end

  antinode_points.length
end

puts "Day 08:"
puts "  Part A: #{day08a(antennae_by_type, grid_bounds)}"
puts "  Part B: #{day08b(antennae_by_type, grid_bounds)}"
