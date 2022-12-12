require 'set'

# neigbors: hash of unique node key to array of neigbors
# costs: optional hash of pairs of unique node keys to their (directed) edge cost
# 
def dijkstra(neighbors:, costs: nil, start_node:, end_node:)
  # populate "unvisited" set
  unvisited_nodes = Set.new(neighbors.keys)

  # populate tentative distances between nodes and starting point. all infinity to begin with
  tentative_distances = neighbors.keys.map { |node| [node, Float::INFINITY] }.to_h
  tentative_distances[start_node] = 0

  # set starting point
  current_node = start_node

  # iterate
  i = 0 # delete me
  while unvisited_nodes.include?(end_node) && i < 1000
    i += 1

    unvisited_neighbors = neighbors[current_node].select { |neighbor| unvisited_nodes.include?(neighbor) }

    unvisited_neighbors.each do |unvisited_neighbor|
      new_neighbor_tentative_distance = tentative_distances[current_node] + (costs.nil? ? 1 : costs.fetch([current_node, unvisited_neighbor], Float::INFINITY))

      if new_neighbor_tentative_distance < tentative_distances[unvisited_neighbor]
        tentative_distances[unvisited_neighbor] = new_neighbor_tentative_distance
      end
    end

    # once all unvisited neighbors have been considered, mark the current node as having been visited
    unvisited_nodes.delete(current_node)

    if unvisited_nodes.include?(end_node) # if we still haven't found it, then set a new current_node to look at
      current_node = tentative_distances.select{ |k, v| unvisited_nodes.include?(k) }.min_by{ |k, v| v }.first
    end
  end

  tentative_distances[end_node]
end


fname = ARGV.shift || 'input.txt'

heightmap =
  File.readlines(fname, chomp: true).map do |line|
    line.chars.map do |char|
      case char
      when 'S'
        0
      when 'E'
        27
      else
        1 + char.ord - 97
      end
    end
  end

hm_height = heightmap.length
hm_width = heightmap.first.length

nbr_directions = [
  [ 1,  0],
  [ 0,  1],
  [-1,  0],
  [ 0, -1]
]

neighbors = {}
start_node = nil
end_node = nil

heightmap.map.with_index do |line, y|
  line.map.with_index do |height, x|
    neighbors[[x, y]] = []

    nbr_directions.each do |dx, dy|
      newx = x + dx
      newy = y + dy

      if (0...hm_width).include?(newx) && (0...hm_height).include?(newy)
        newheight = heightmap[y][x]

        if (!newheight.nil?) && (newheight - height).abs <= 1
          neighbors[[x, y]] << [newx, newy]
        end
      end
    end

    if height == 0
      start_node = [x, y]
    end

    if height == 27
      end_node = [x, y]
    end
  end
end

p dijkstra(neighbors: neighbors, start_node: start_node, end_node: end_node)
p neighbors
