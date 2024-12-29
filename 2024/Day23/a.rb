NODES = {}
ORDERED_EDGES = {}

File.readlines('input.txt', chomp: true).each do |line|
  node1, node2 = line.split(/-/)

  ORDERED_EDGES[[node1, node2]] = true
  ORDERED_EDGES[[node2, node1]] = true

  NODES[node1] = [] unless NODES.key?(node1)
  NODES[node2] = [] unless NODES.key?(node2)

  NODES[node1] << node2
  NODES[node2] << node1
end

triplets = {}
NODES.select { |node, _| node =~ /^t/ }.each do |first_node, second_nodes|
  second_nodes.each do |second_node|
    NODES[second_node].each do |third_node, _|
      if ORDERED_EDGES[[first_node, third_node]]
        triplets[ [first_node, second_node, third_node].sort ] = true
      end
    end
  end
end

p triplets.length

# def largest_clique_containing(curr_node, other_nodes)
#   new_members =
#     NODES[curr_node].select do |curr_node_nbr|
#       other_nodes.all? do |other_node|
#         ORDERED_EDGES[[curr_node_nbr, other_node]]
#       end
#     end
# end
