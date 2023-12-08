def path_length(nodes, instructions, starting_node, end_pattern)
  current_node = starting_node.dup

  steps = 0
  until current_node =~ end_pattern
    case instructions[steps % instructions.length]
    when 'L'
      current_node = nodes[current_node].first
    when 'R'
      current_node = nodes[current_node].last
    else
      raise "Bad instruction #{instruction.inspect}"
    end

    steps += 1
    current_node
  end

  steps
end

def day08a(nodes, instructions)
  path_length(nodes, instructions, 'AAA', /ZZZ/)
end

def day08b(nodes, instructions)
  starting_nodes = nodes.keys.grep(/..A/)
  path_lengths =
    starting_nodes.map do |starting_node|
      [starting_node, path_length(nodes, instructions, starting_node, /..Z/)]
    end.to_h

  result = path_lengths.values.reduce { |a, b| a.lcm(b) }

  result
end

fname = ARGV.shift || 'input.txt'
instructions, nodes_str = File.read(fname, chomp: true).split(/\n\n/)
nodes =
  nodes_str.split(/\n/).map do |node_str|
    parent, left, right = node_str.match(/(...) = \((...), (...)\)/).to_a.drop(1)

    [parent, [left, right]]
  end.to_h

puts 'Day 08:'
puts "  Part A: #{day08a(nodes, instructions)}"
puts "  Part B: #{day08b(nodes, instructions)}"
