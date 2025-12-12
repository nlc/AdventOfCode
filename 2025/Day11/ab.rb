FWD = {} # map node to descendants
REV = {} # map node to predecessors

ifname = 'input.txt'

File.readlines(ifname, chomp: true).each do |line|
  node, descendants_str = line.split(/: /)
  descendants = descendants_str.split(/ /)

  FWD[node] = descendants
  descendants.each do |descendant|
    REV[descendant] = [] unless REV.key?(descendant)
    REV[descendant] << node
  end
end

MEMO_COUNT_PATHS = { }
def count_paths(start_node, end_node)
  k = [start_node, end_node]

  return MEMO_COUNT_PATHS[k] if MEMO_COUNT_PATHS.key?(k)

  return MEMO_COUNT_PATHS[k] = 0 unless REV.key?(end_node)

  return MEMO_COUNT_PATHS[k] = 1 if FWD[start_node].include?(end_node)

  MEMO_COUNT_PATHS[k] =
    REV[end_node].sum do |predecessor|
      count_paths(start_node, predecessor)
    end

  MEMO_COUNT_PATHS[k]
end

def day11a
  count_paths('you', 'out')
end

def day11b
  count_paths('svr', 'dac') * count_paths('dac', 'fft') * count_paths('fft', 'out') +
  count_paths('svr', 'fft') * count_paths('fft', 'dac') * count_paths('dac', 'out')
end

puts "Day 11:"
puts "  Part A: #{day11a}"
puts "  Part B: #{day11b}"
