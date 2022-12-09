class Knot
  attr_accessor :x, :y, :length, :visited

  def initialize(x, y)
    @x = x
    @y = y

    @visited = {[@x, @y] => true}
  end

  def follow(knot)
    connected = false

    until connected
      dx = knot.x - @x
      dy = knot.y - @y

      displacement_moves = {
        [ 2,  0] => [ 1,  0],
        [ 2,  1] => [ 1,  1],
        [ 2,  2] => [ 1,  1],
        [ 1,  2] => [ 1,  1],
        [ 0,  2] => [ 0,  1],
        [-1,  2] => [-1,  1],
        [-2,  2] => [-1,  1],
        [-2,  1] => [-1,  1],
        [-2,  0] => [-1,  0],
        [-2, -1] => [-1, -1],
        [-2, -2] => [-1, -1],
        [-1, -2] => [-1, -1],
        [ 0, -2] => [ 0, -1],
        [ 1, -2] => [ 1, -1],
        [ 2, -2] => [ 1, -1],
        [ 2, -1] => [ 1, -1],
      }

      move = displacement_moves[[dx.clamp(-2..2), dy.clamp(-2..2)]]
      if move.nil?
        connected = true
      else
        mx, my = move

        @x += mx
        @y += my
      end

      @visited[[@x, @y]] = true
    end
  end

  def step(direction)
    case direction
    when :R
      @x += 1
    when :U
      @y += 1
    when :L
      @x -= 1
    when :D
      @y -= 1
    end

    @visited[[@x, @y]] = true
  end
end

# def draw(head, tails, halfside)
#   side = 1 + halfside * 2
#   grid = Array.new(side) { Array.new(side) { '.' } }
# 
#   (0...(tails.length)).to_a.reverse.each do |i|
#     tail = tails[i]
#     grid[tail.y + halfside + 1][tail.x + halfside + 1] = (i + 1).to_s
#   end
# 
#   grid[head.y + halfside + 1][head.x + halfside + 1] = 'H'
# 
#   puts grid.reverse.map(&:join).join("\n")
# end

input = File.readlines('input.txt', chomp: true)

knots = Array.new(10) { Knot.new(0, 0) }

input.each do |instruction|
  direction, distance = instruction.split
  direction = direction.to_sym
  distance = distance.to_i

  distance.times do
    knots[0].step(direction)

    (1...knots.length).each do |i|
      knots[i].follow(knots[i - 1]) if i > 0
    end
  end
end

puts knots[-1].visited.length
