def compare(left, right)
  case [left, right]
  in [NilClass, *] # left ran out
    -1
  in [*, NilClass] # right ran out
    1
  in [Integer, Integer]
    left <=> right
  in [Integer, Array]
    compare([left], right)
  in [Array, Integer]
    compare(left, [right])
  in [Array, Array]
    left.zip(right).each do |subleft, subright|
      comparison = compare(subleft, subright)
      return comparison unless comparison == 0
    end

    left.length <=> right.length
  end
end

def day13a(input_raw)
  input = input_raw.split(/\n\n/).map{|pair_str|pair_str.split(/\n/).map{ |str| eval str } }

  input.map.with_index do |pair, i|
    addend = (compare(*pair) < 1) ? (i + 1) : 0

    addend
  end.sum
end

def day13b(input_raw)
  input = input_raw.split(/\n+/).map{ |str| eval str }

  magic1 = [[2]]
  magic2 = [[6]]
  sorted = (input + [magic1, magic2]).sort { |a, b| compare(a, b) }
  (sorted.index(magic1) + 1) * (sorted.index(magic2) + 1)
end

fname = ARGV.shift || 'input.txt'
input_raw = File.read(fname)

puts 'Day 13:'
puts "  Part A: #{day13a(input_raw)}"
puts "  Part B: #{day13b(input_raw)}"
