fname = ARGV.shift || 'input.txt'

grid = File.readlines(fname, chomp: true).map { |line| line.chars.map { |char| char.to_i } }
p grid

# cost[path] = cost[path_tail] + cost[path_last]
# min_cost[path] - min(min_cost[left_path], min_cost[right_path])
# Trivially, a minimal path is non-self-intersecting, may be useful


