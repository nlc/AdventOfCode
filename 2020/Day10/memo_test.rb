# Test if the quickie "memo.rb" include will perform the
# same as manually memoizing.
# Turns out it's almost exactly the same performance in this case.

require '../../utilities/memo.rb'

# return the chain that starts with <adapter> and makes it to <target>
def full_chain(adapter, target, neighbors)
  return [adapter] if adapter == target

  if neighbors.key? adapter
    results =
      neighbors[adapter].map do |neighbor|
        _memo(:full_chain, neighbor, target, neighbors)
      end
    result = [adapter] + results.max_by { |r| r.length }
    result
  end
end

def count_chain(adapter, target, neighbors)
  return 1 if adapter == target

  if neighbors.key? adapter
    results =
      neighbors[adapter].map do |neighbor|
        _memo(:count_chain, neighbor, target, neighbors)
      end
    result = results.inject(:+)
    result
  end
end

test1_raw_adapters = File.readlines('puzzle.txt', chomp: true)[32..42].map(&:to_i)
test2_raw_adapters = File.readlines('puzzle.txt', chomp: true)[73..103].map(&:to_i)
raw_adapters = File.readlines('input.txt', chomp: true).map(&:to_i)

# An adapter is allowed to connect to another adapter
# with a value of 1-3 less than itself

def init_neighbors(adapters)
  neighbors = {}
  adapters.product(adapters).select do |a, b|
    (1..3).include?(b - a)
  end.each do |a, b|
    neighbors[a] = [] unless neighbors.key? a
    neighbors[a] << b
  end

  neighbors
end

def part_a(raw_adapters)
  adapters = raw_adapters.clone

  first_adapter = 0
  last_adapter = adapters.max + 3
  adapters << first_adapter
  adapters << last_adapter

  neighbors = init_neighbors(adapters)

  fc = full_chain(first_adapter, last_adapter, neighbors)
  diffs = fc.each_cons(2).map { |pair| pair[1] - pair[0] }.group_by{|x|x}
  diffs.map { |k, v| [k, v.length]}.to_h
end

def part_b(raw_adapters)
  adapters = raw_adapters.clone

  first_adapter = 0
  last_adapter = adapters.max + 3
  adapters << first_adapter
  adapters << last_adapter

  neighbors = init_neighbors(adapters)

  count_chain(first_adapter, last_adapter, neighbors)
end

puts "\033[1mPART A:\033[0m"
test1_counts_a = part_a(test1_raw_adapters)
test2_counts_a = part_a(test2_raw_adapters)
test1_ans_a = test1_counts_a.values.inject(:*)
test2_ans_a = test2_counts_a.values.inject(:*)
puts "  TEST 1: #{test1_counts_a} --> \033[1m#{test1_ans_a}\033[0m"
puts "  TEST 2: #{test2_counts_a} --> \033[1m#{test2_ans_a}\033[0m"

counts_a = part_a(raw_adapters)
ans_a = counts_a.values.inject(:*)
puts "  ACTUAL: #{counts_a} --> \033[1m#{ans_a}\033[0m"
puts

puts "\033[1mPART B:\033[0m"
puts "  TEST 1: \033[1m#{part_b(test1_raw_adapters)}\033[0m"
puts "  TEST 2: \033[1m#{part_b(test2_raw_adapters)}\033[0m"
puts "  ACTUAL: \033[1m#{part_b(raw_adapters)}\033[0m"
