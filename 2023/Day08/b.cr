# Preserved for posterity

if ARGV.size > 0
  fname = ARGV.first
else
  fname = "input.txt"
end

instructions, nodes_str = File.read(fname).split(/\n\n/)
instructions = instructions.chars

nodes = Hash(String, Array(String)).new

nodes_str.split(/\n/).map do |node_str|
  match_data = node_str.match(/(...) = \((...), (...)\)/)

  unless match_data.nil?
    parent = match_data[1]
    left = match_data[2]
    right = match_data[3]

    nodes[parent] = [left, right]
  end
end

current_nodes = nodes.keys.select{|node|node =~ /..A/}
steps = 0_u128
until current_nodes.all?{|current_node| current_node =~ /..Z/}
  instruction = instructions[steps % instructions.size]

  case instruction
  when 'L'
    current_nodes.map! do |current_node|
      nodes[current_node].first
    end
  when 'R'
    current_nodes.map! do |current_node|
      nodes[current_node].last
    end
  else
    raise "Bad instruction #{instruction.inspect}"
  end

  steps += 1
  p steps if steps % 100000 == 0
end

p steps
