require 'pp'

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

tiles =
  File.read(fname).split(/\n\n/).map do |chunk|
    lines = chunk.split(/\n/)
    index = lines.shift.gsub(/Tile (\d+):/, '\1')
    chars = lines.map(&:chars)

    # top, bottom, left, right
    edge_strs = Array.new(4) { '' }
    edges = Array.new(4) { 0 }

    10.times do |i|
      edge_strs[0] << chars[0][i] # top
      edge_strs[1] << chars[9][i] # bottom
      edge_strs[2] << chars[i][0] # left
      edge_strs[3] << chars[i][9] # right
    end

    edges =
      edge_strs.map do |edge_str|
        bin_str = edge_str.gsub(/[\.#]/, { '.' => 0, '#' => 1 } )
        [bin_str.to_i(2), bin_str.reverse.to_i(2)].min
      end

    [
      index.to_i,
      {
        chars: chars,
        edges: edges,
        neighbors: {}
      }
    ]
  end.to_h

# Cross-reference by edge numbers
tiles.length.times do |i|
  i.times do |j|
    next if i == j
    commons = tiles.values[i][:edges] & tiles.values[j][:edges]
    if commons.length == 1
      common = commons.first
      tiles.values[i][:neighbors][%i[north south west east][tiles.values[i][:edges].index(common)]] = tiles.keys[j]
      tiles.values[j][:neighbors][%i[north south west east][tiles.values[j][:edges].index(common)]] = tiles.keys[i]
    elsif commons.length > 1
      raise 'Two common edges found!!!!'
    end
  end
end

corner_ids =
  tiles.select do |_key, tile|
    tile[:neighbors].length == 2
  end.keys
edge_ids =
  tiles.select do |_key, tile|
    tile[:neighbors].length == 3
  end.keys
filler_ids =
  tiles.select do |_key, tile|
    tile[:neighbors].length == 4
  end.keys
illegal_ids =
  tiles.select do |_key, tile|
    !(2..4).include?(tile[:neighbors].length)
  end.keys
raise("#{illegal_ids.inspect} have an imposisble number of neighbors!") if illegal_ids.any?

# puts "Part A: \033[1m#{corner_ids.inject(:*)}\033[0m"

opposite_directions = {
  north: :south,
  south: :north,
  west: :east,
  east: :west
}

corner_ids.each do |corner_id|
  corner = tiles[corner_id]
  corner[:neighbors].each do |_direction, neighbor_id|
    
  end
end
