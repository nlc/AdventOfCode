fname = ARGV.shift || 'input.txt'

instructions, nodes_str = File.read(fname, chomp: true).split(/\n\n/)

nodes =
  nodes_str.split(/\n/).map do |node_str|
    parent, left, right = node_str.match(/([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)/).to_a.drop(1)

    [parent, [left, right]]
  end.to_h

p nodes

node = 'AAA'
steps = 0
until node == 'ZZZ'
  instruction = instructions[steps % instructions.length]

  case instruction
  when 'L'
    node = nodes[node].first
  when 'R'
    node = nodes[node].last
  else
    raise "Bad instruction #{instruction.inspect}"
  end

  steps += 1
  p node
end

p steps
