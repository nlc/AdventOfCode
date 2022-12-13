def compare(left, right)
  print "  #{left.inspect} VS #{right.inspect}  " if $debug
  case [left, right]
  in [NilClass, *] # left ran out
    puts "left ran out of inputs" if $debug
    return -1
  in [*, NilClass] # right ran out
    puts "right ran out of inputs" if $debug
    return 1
  in [Integer, Integer]
    puts "integers; left <=> right" if $debug
    return left <=> right
  in [Integer, Array]
    puts "mixed types, convert left to [#{left}] and retry" if $debug
    return compare([left], right)
  in [Array, Integer]
    puts "mixed types, convert right to [#{right}] and retry" if $debug
    return compare(left, [right])
  in [Array, Array]
    puts "arrays; try each" if $debug

    left.zip(right).each do |subleft, subright|
      comparison = compare(subleft, subright)
      return comparison unless comparison == 0
    end

    return left.length <=> right.length
  end

  raise 'oops'
end

def day13a(input_raw)
  input = input_raw.split(/\n\n/).map{|pair_str|pair_str.split(/\n/).map{ |str| eval str } }

  input.map.with_index do |pair, i|
    addend = (compare(*pair) < 1) ? (i + 1) : 0
    puts if $debug

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

p day13a(input_raw)
p day13b(input_raw)
