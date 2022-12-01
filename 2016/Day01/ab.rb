class Walker
  TRANSITIONS = {
    E: { R: :S, L: :N },
    N: { R: :E, L: :W },
    W: { R: :N, L: :S },
    S: { R: :W, L: :E }
  }

  attr_accessor :x, :y, :d

  def initialize(x, y, d)
    @x = x
    @y = y
    @d = d
  end

  def follow(instruction)
    side = instruction[0].to_sym
    distance = instruction[1..].to_i

    turn(side)
    walk(distance)
  end

  def magnitude
    @x.abs + @y.abs
  end

  private

  def turn(side)
    @d = TRANSITIONS[@d][side]
  end

  def walk(distance)
    case @d
    when :E
      @x += distance
    when :N
      @y += distance
    when :W
      @x -= distance
    when :S
      @y -= distance
    end
  end
end

class Visitor < Walker
  attr_accessor :visited

  def initialize(x, y, d)
    super(x, y, d)

    @visited = {}
  end

  private

  def been_here?
    @visited.key? [@x, @y]
  end

  def walk(distance)
    distance.times do
      case @d
      when :E
        @x += 1
      when :N
        @y += 1
      when :W
        @x -= 1
      when :S
        @y -= 1
      end

      if been_here?
        return true
      end

      @visited[[@x, @y]] = true
    end

    false
  end
end

instructions = File.read('input.txt').split(/, /)
# instructions = %w[R8 R4 R4 R8]

walker = Walker.new(0, 0, :N)
instructions.each do |instruction|
  walker.follow(instruction)
end
puts "Part A: #{walker.magnitude}"

visitor = Visitor.new(0, 0, :N)
instructions.each do |instruction|
  break if visitor.follow(instruction)
  # puts "Crossing at <#{visitor.x}, #{visitor.y}>" if visitor.follow(instruction)
end
puts "Part B: #{visitor.magnitude}"
