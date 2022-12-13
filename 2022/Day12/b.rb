require './dijkstra.rb'

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
plains_nodes = []
summit_node = nil

heightmap.map.with_index do |line, y|
  line.map.with_index do |height, x|
    neighbors[[x, y]] = []

    nbr_directions.each do |dx, dy|
      newx = x + dx
      newy = y + dy

      if (0...hm_width).include?(newx) && (0...hm_height).include?(newy)
        newheight = heightmap[newy][newx]

        if (!newheight.nil?) && height - newheight <= 1
          neighbors[[x, y]] << [newx, newy]
        end
      end
    end

    if height == 1
      plains_nodes << [x, y]
    end

    if height == 27
      summit_node = [x, y]
    end
  end
end

tentative_distances, _ = dijkstra(neighbors: neighbors, start_node: summit_node)

puts plains_nodes.map { |plains_node| tentative_distances[plains_node] }.min
