require 'pp'

# return a list of all chains that start with <adapter>
def chain(adapter, neighbors)
  {
    adapter =>
    if neighbors.key? adapter
      neighbors[adapter].map do |neighbor|
        chain(neighbor, neighbors)
      end
    end
  }
end

# return the chain that starts with <adapter> and makes it to <target>
$full_chain_memo = {}
def full_chain(adapter, target, neighbors)
  # Memoize

  return [adapter] if adapter == target

  if $full_chain_memo.key?([adapter, target, neighbors])
    $full_chain_memo[[adapter, target, neighbors]]
  elsif neighbors.key? adapter
    results =
      neighbors[adapter].map do |neighbor|
        full_chain(neighbor, target, neighbors)
      end
    result = [adapter] + results.max_by { |r| r.length }
    $full_chain_memo[[adapter, target, neighbors]] = result
    result
  end
end

test_raw_adapters = File.readlines('temp.txt', chomp: true)[73..103].map(&:to_i)
raw_adapters = File.readlines('input.txt', chomp: true).map(&:to_i)

# An adapter is allowed to connect to another adapter
# with a value of 1-3 less than itself

def part_a(raw_adapters)
  adapters = raw_adapters.clone

  first_adapter = 0
  last_adapter = adapters.max + 3 
  adapters << first_adapter
  adapters << last_adapter

  neighbors = {}
  adapters.product(adapters).select do |a, b|
    (1..3).include?(b - a)
  end.each do |a, b|
    neighbors[a] = [] unless neighbors.key? a
    neighbors[a] << b
  end

  fc = full_chain(first_adapter, last_adapter, neighbors)
  diffs = fc.each_cons(2).map { |pair| pair[1] - pair[0] }.group_by{|x|x}
  diffs.map { |k, v| [k, v.length]}.to_h
end

puts "TEST"
pp part_a(test_raw_adapters)
puts "ACTUAL"
pp part_a(raw_adapters)
