trees = File.readlines('input.txt').map{|line|line.chomp.chars.map(&:to_i)}
# trees = File.readlines('sample.txt').map{|line|line.chomp.chars.map(&:to_i)}
# trees = File.readlines('sample2.txt').map{|line|line.chomp.chars.map(&:to_i)}

h = trees.length
w = trees.first.length

num_visible = 0

max_score = 0

(1...(h-1)).each do |y|
  (1...(w-1)).each do |x|
# h.times do |y|
#   w.times do |x|
    tree = trees[y][x]

    distance = []

    # Right
    result = (trees[y][(x+1)..].each_with_index.find{|e, i| e >= tree})
    if result.nil?
      distance << w - x - 1
    else
      index = result[1]
      distance << index + 1
    end

    # Left
    result = (trees[y][...(x)].reverse.each_with_index.find{|e, i| e >= tree})
    if result.nil?
      distance << x
    else
      index = result[1]
      distance << index + 1
    end

    # Up
    result = (trees[...(y)].map{_1[x]}.reverse.each_with_index.find{|e, i| e >= tree})
    if result.nil?
      distance << y
    else
      index = result[1]
      distance << index + 1
    end

    # Down
    result = (trees[(y+1)..].map{_1[x]}.each_with_index.find{|e, i| e >= tree})
    if result.nil?
      distance << h - y - 1
    else
      index = result[1]
      distance << index + 1
    end


    score = distance.inject(:*)
    if score > max_score
      max_score = score
    end
  end
end



perimeter = 2 * ((w - 1) + (h - 1))
interior = num_visible
total = perimeter + interior

puts "#{perimeter} on the edge + #{interior} in the interior = #{total}"

puts "max score = #{max_score}"
