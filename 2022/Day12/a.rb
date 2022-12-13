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
start_node = nil
end_node = nil

heightmap.map.with_index do |line, y|
  line.map.with_index do |height, x|
    neighbors[[x, y]] = []

    nbr_directions.each do |dx, dy|
      newx = x + dx
      newy = y + dy

      if (0...hm_width).include?(newx) && (0...hm_height).include?(newy)
        newheight = heightmap[newy][newx]

        if (!newheight.nil?) && newheight - height <= 1
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

tentative_distances, _ = dijkstra(neighbors: neighbors, start_node: start_node, end_node: end_node)
puts tentative_distances[end_node]
