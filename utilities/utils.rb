require 'pp'

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

inp = 'input.txt'

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
    @d = TURN_TRANSITIONS[@d][side]
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
