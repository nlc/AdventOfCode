trees = File.readlines('input.txt').map{|line|line.chomp.chars.map(&:to_i)}

h = trees.length
w = trees.first.length

num_visible = 0

max_score = 0

(1...(h-1)).each do |y|
  (1...(w-1)).each do |x|
    tree = trees[y][x]

    sightlines = []

    # Right
    result = (trees[y][(x+1)..].each_with_index.find{|e, i| e >= tree})
    if result.nil?
      sightlines << w - x - 1
    else
      index = result[1]
      sightlines << index + 1
    end

    # Left
    result = (trees[y][...(x)].reverse.each_with_index.find{|e, i| e >= tree})
    if result.nil?
      sightlines << x
    else
      index = result[1]
      sightlines << index + 1
    end

    # Up
    result = (trees[...(y)].map{_1[x]}.reverse.each_with_index.find{|e, i| e >= tree})
    if result.nil?
      sightlines << y
    else
      index = result[1]
      sightlines << index + 1
    end

    # Down
    result = (trees[(y+1)..].map{_1[x]}.each_with_index.find{|e, i| e >= tree})
    if result.nil?
      sightlines << h - y - 1
    else
      index = result[1]
      sightlines << index + 1
    end

    score = sightlines.inject(:*)
    if score > max_score
      max_score = score
    end
  end
end

puts "max scenic score = #{max_score}"
