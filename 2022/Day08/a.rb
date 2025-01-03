trees = File.readlines('input.txt').map{|line|line.chomp.chars.map(&:to_i)}

h = trees.length
w = trees.first.length

num_visible = 0

(1...(h-1)).each do |y|
  (1...(w-1)).each do |x|
    tree = trees[y][x]

    is_visible = false
    visibility = []

    biggest_rightward = trees[y][(x+1)..].max || 0
    if tree > biggest_rightward
      is_visible = true
      # visibility << 'RIGHT'
    end

    biggest_leftward = trees[y][...(x)].max || 0
    if tree > biggest_leftward
      is_visible = true
      # visibility << 'LEFT'
    end

    biggest_upward = trees[...(y)].map{_1[x]}.max || 0
    if tree > biggest_upward
      is_visible = true
      # visibility << 'UP'
    end

    biggest_downward = trees[(y+1)..].map{_1[x]}.max || 0
    if tree > biggest_downward
      is_visible = true
      # visibility << 'DOWN'
    end

    if is_visible
      # puts "#{tree} at <#{x}, #{y}> is visible from #{visibility.join('/')}!"
      num_visible += 1
    end
  end
end

perimeter = 2 * ((w - 1) + (h - 1))
interior = num_visible
total = perimeter + interior

puts "#{perimeter} on the edge + #{interior} in the interior = #{total}"
