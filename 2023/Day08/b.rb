fname = ARGV.shift || 'input.txt'

instructions, nodes_str = File.read(fname, chomp: true).split(/\n\n/)

nodes =
  nodes_str.split(/\n/).map do |node_str|
    parent, left, right = node_str.match(/(...) = \((...), (...)\)/).to_a.drop(1)

    [parent, [left, right]]
  end.to_h

p nodes

p current_nodes = nodes.keys.grep(/..A/)
steps = 0
until current_nodes.all?{|current_node| current_node =~ /..Z/}
  instruction = instructions[steps % instructions.length]

  case instruction
  when 'L'
    current_nodes.map!{|current_node|nodes[current_node].first}
  when 'R'
    current_nodes.map!{|current_node|nodes[current_node].last}
  else
    raise "Bad instruction #{instruction.inspect}"
  end

  steps += 1 
  p steps if steps % 100000 == 0
  # p current_nodes
end

p steps
