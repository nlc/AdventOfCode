class Rope
  attr_accessor :x, :y, :visited

  def initialize(x, y)
    @tx = @lhx = @hx = x
    @ty = @lhy = @hy = y

    @visited = {}
  end

  def follow(instruction)
    direction, distance = instruction.split
    direction = direction.to_sym
    distance = distance.to_i

    walk(direction, distance)
  end

  def step(direction)
    @lhx = @hx
    @lhy = @hy

    case direction
    when :R
      @hx += 1
    when :U
      @hy += 1
    when :L
      @hx -= 1
    when :D
      @hy -= 1
    end

    if stretched
      @tx = @lhx
      @ty = @lhy
    end

    @visited[[@tx, @ty]] = true
  end

  def walk(direction, distance)
    distance.times { step(direction) }
  end

  def stretched
    (@hx - @tx).abs > 1 || (@hy - @ty).abs > 1
  end
end

input = File.readlines('input.txt', chomp: true)

rope = Rope.new(0, 0)

input.each do |instruction|
  rope.follow(instruction)
end


p rope.visited.length
