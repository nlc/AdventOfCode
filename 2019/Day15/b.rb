require 'byebug'

require_relative '../intcode.rb'

class Solver
  def addvec(a, b)
    a.zip(b).map{|ai, bi| ai + bi}
  end

  def initialize(robotx = 0, roboty = 0)
    @statuses = {
      0 => 'blocked',
      1 => 'moved',
      2 => 'found'
    }

    @directions = {
      1 => [0, -1],
      2 => [0, 1],
      3 => [-1, 0],
      4 => [1, 0] 
    }

    @oppdir = {
      1 => 2,
      2 => 1,
      4 => 3,
      3 => 4
    }

    @targetdist = nil
    @doors = {} # [x, y] => possible outlets
    @visited = {} # [x, y] => pathlength

    @intcode = Intcode.new('input.txt')
    @intcode.execute # looks like it needs to do some preprocessing

    @robotloc = [robotx, roboty]

    @path = []

    @doneseek = false
  end

  def visited
    @visited
  end

  def clear
    @path = []
    @visited = {}
  end

  def path
    @path
  end

  def totalpath
    @totalpath
  end

  def takepath(path)
    path.each do |step|
      @path << step
      @robotloc = addvec(@robotloc, @directions[step])
      result = @intcode.execute(step).first
      raise 'oops' if result == 0
    end
  end

  def search()
    # p @path
    if @visited[@robotloc]
      @visited[@robotloc] = [@visited[@robotloc], @path.length].min
    else
      @visited[@robotloc] = @path.length
    end

    # what options do i have
    unless @doors[@robotloc]
      @doors[@robotloc] = []
      @directions.keys.each do |dir|
        result = @intcode.execute(dir).first
        unless result == 0
          @doors[@robotloc] << dir
          result = @intcode.execute(@oppdir[dir]).first
          if result == 0
            raise 'failed to undo move!!!'
          end
        end
      end
    end

    origloc = @robotloc
    options = @doors[@robotloc]
    if @path.length > 0
      options = options - [ @oppdir[@path.last] ]
    end

    options.each do |option|
      result = @intcode.execute(option).first
      if result == 0
        raise 'this should be impossible'
      else
        @path << option
        @robotloc = addvec(@robotloc, @directions[option])
        if result == 2
          @totalpath = @path.clone
          p @robotloc
          p @path.length
          search
        elsif result == 1
          search
        else
          raise "impossible result #{result}"
        end
      end

      result = @intcode.execute(@oppdir[option]).first
      if result == 0
        raise 'failed to backtrack!!!'
      end
      @path.pop
      @robotloc = addvec(@robotloc, @directions[@oppdir[option]])

      if @robotloc != origloc
        raise "#{@robotloc} should be #{origloc}"
      end
    end
  end
end

solver = Solver.new

solver.search
path = solver.totalpath

solver = Solver.new
solver.takepath(path)
solver.clear
solver.search

p solver.visited.values.sort.last
