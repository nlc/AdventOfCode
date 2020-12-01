graph = {} of String => Set(String)
parents_of = {} of String => Set(String)

non_frontier = Set(String).new

File.read_lines("graph.txt").map do |vertex|
  k, v = vertex.split(/ /)

  non_frontier << v

  if graph.has_key? k
    graph[k] << v
  else
    graph[k] = [v].to_set
  end

  if parents_of.has_key? v
    parents_of[v] << k
  else
    parents_of[v] = [k].to_set
  end
end

# Ideally this would be some kind of heap. Whatever, N = 26.
frontier = Set.new(graph.keys) - non_frontier

while(!frontier.empty?)
  next_node = frontier.to_a.sort { |a, b| a <=> b }.first
  print "%s" % next_node

  if graph.has_key? next_node
    graph[next_node].each do |child|
      if parents_of.has_key? child
        parents_of[child].delete(next_node)

        if parents_of[child].empty?
          frontier << child
        end
      end
    end
  end

  frontier.delete(next_node)
end

puts
