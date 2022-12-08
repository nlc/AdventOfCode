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
    p biggest_rightward
    if tree > biggest_rightward
      is_visible = true
      visibility << 'RIGHT'
    end
    biggest_leftward = trees[y][...(x)].max || 0
    p biggest_leftward
    if tree > biggest_leftward
      is_visible = true
      visibility << 'LEFT'
    end
    biggest_upward = trees[...(y)].map{_1[x]}.max || 0
    p biggest_upward
    if tree > biggest_upward
      is_visible = true
      visibility << 'UP'
    end
    biggest_downward = trees[(y+1)..].map{_1[x]}.max || 0
    p biggest_downward
    if tree > biggest_downward
      is_visible = true
      visibility << 'DOWN'
    end
    if x == 0 || x == (w - 1) || y == 0 || y == (h - 1)
      is_visible = true
    end

    if is_visible
      puts "#{tree} at <#{x}, #{y}> is visible from #{visibility.join('/')}!"
      num_visible += 1
    end
  end
end

trees.each do |row|
  puts row.join
end

perimeter = 2 * ((w - 1) + (h - 1))
interior = num_visible
total = perimeter + interior

puts "#{perimeter} on the edge + #{interior} in the interior = #{total}"
