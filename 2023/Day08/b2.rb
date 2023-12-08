fname = ARGV.shift || 'input.txt'

instructions, nodes_str = File.read(fname, chomp: true).split(/\n\n/)

nodes =
  nodes_str.split(/\n/).map do |node_str|
    parent, left, right = node_str.match(/(...) = \((...), (...)\)/).to_a.drop(1)

    [parent, [left, right]]
  end.to_h

starting_nodes = nodes.keys.grep(/..A/)

path_lengths =
  starting_nodes.map do |starting_node|
    steps = 0
    current_node = starting_node.dup

    until current_node =~ /..Z/
      instruction = instructions[steps % instructions.length]

      case instruction
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

    [starting_node, steps]
  end.to_h

result =
  path_lengths.values.reduce do |a, b|
    a.lcm(b)
  end

p result
