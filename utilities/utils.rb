require 'pp'
inp = 'input.txt'

def readlines(fname)
  File.readlines(fname, chomp: true)
end

def ireadlines(fname)
  readlines(fname).map(&:to_i)
end

def readgrid(fname)
  readlines.map(&:chars)
end

def ireadgrid(fname)
  readlines.map { |line| line.chars.map(&:to_i) }
end

def readchars(fname)
  File.read(fname)
end

def ireadchars(fname)
  readchars(fname).map(&:to_i)
end

def readwords(fname)
  File.read(fname).split(/\s+/)
end

def ireadwords(fname)
  readwords(fname).map(&:to_i)
end

# BEGIN:Basic array vector math
def vsubtract(a1, a2)
  a1.zip(a2).map { |e1, e2| e1 - e2 }
end

def vadd(a1, a2)
  a1.zip(a2).map { |e1, e2| e1 + e2 }
end

def vnegative(a)
  a.map(&:-@)
end

def vinbounds?(a, bounds)
  a.zip(bounds).all? do |e, dim|
    dimmin, dimmax = dim

    e >= dimmin && e < dimmax
  end
end

def vdot(a1, a2)
  a1.zip(a2).sum { |e1, e2| e1 * e2 }
end
# END:Basic array vector math

class WalkerBase
  TURN_TRANSITIONS = {
    E: { R: :S, L: :N, F: :E, B: :W },
    N: { R: :E, L: :W, F: :N, B: :S },
    W: { R: :N, L: :S, F: :W, B: :E },
    S: { R: :W, L: :E, F: :S, B: :N }
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

  def turn(side)
    if TURN_TRANSITIONS[@d].key?(side)
      @d = TURN_TRANSITIONS[@d][side]
    elsif [:E, :N, :W, :S].include?(side) # Allow to e.g. "turn north" regardless of direction
      @d = side
    end
  end

  def walk(distance) # Walk forward
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

  def step(direction, distance=1) # Step forward, backward, left or right
    orig_direction = @d

    turn(direction)
    walk(distance)

    @d = orig_direction
  end
end

def parallel_map(array, &block)
  threads = []
    results = Array.new(array.size)

  array.each_with_index do |element, index|
    threads << Thread.new do
      results[index] = block.call(element)
    end
  end

  threads.each(&:join)

  results
end

def parallel_map_with_index(array, &block)
  threads = []
    results = Array.new(array.size)

  array.each_with_index do |element, index|
    threads << Thread.new do
      results[index] = block.call(element, index)
    end
  end

  threads.each(&:join)

  results
end
