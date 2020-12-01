require 'byebug'

require_relative '../intcode.rb'

def addvec(a, b)
  puts "add #{a} to #{b}"
  a.zip(b).map{|ai, bi| ai + bi}
end

statuses = {
  0 => 'blocked',
  1 => 'moved',
  2 => 'found'
}

directions = {
  1 => [0, -1],
  2 => [0, 1],
  3 => [-1, 0],
  4 => [1, 0] 
}

oppdir = {
  1 => 2,
  2 => 1,
  4 => 3,
  3 => 4
}

intcode = Intcode.new('input.txt')
intcode.execute # looks like it needs to do some preprocessing

robotloc = [0, 0]
camefrom = nil

targetloc = nil

exits = {}

# dfs stack
pathstack = []

def search(intcode, exits, robotloc, directions, statuses, camefrom, pathstack, oppdir)
  # puts "robotloc = #{robotloc}"
  # puts "stack length = #{pathstack.length}"

  topleveloldrobotloc = robotloc

  unless exits.key? robotloc
    exits[robotloc] = {}
  end

  # choose exit
  possdirs =
    directions.keys.select do |dirnum|
      (!(exits[robotloc].key? dirnum)) || exits[robotloc][dirnum] == true
    end
  if camefrom
    possdirs = possdirs - [camefrom]
  end

  # if possdirs.empty?
  #   robotloc = addvec(robotloc, directions[oppdir[pathstack.pop]])
  # end

  # puts "possible directions: #{possdirs}"

  possdirs.each do |dir|
    # puts "choosing #{dir}"
    # gets

    resp = intcode.execute(dir).first
    case statuses[resp]
    when 'blocked'
      exits[robotloc][dir] = false
    when 'moved'
      if exits[robotloc].nil?
        byebug
      end
      exits[robotloc][dir] = true
      oldrobotloc = robotloc
      robotloc = addvec(robotloc, directions[dir])

      pathstack << dir

      camefrom = oppdir[dir]

      res = search(intcode, exits, robotloc, directions, statuses, camefrom, pathstack, oppdir)
      if res.nil?
        # # that direction has no prospect. undo move.
        # robotloc = addvec(robotloc, directions[oppdir[pathstack.pop]])
        # if robotloc != oldrobotloc
        #   raise "#{robotloc} did not return to #{oldrobotloc}"
        # end
        robotloc = oldrobotloc
        pathstack.pop
      else
        # we found something
        return res
      end
    when 'found'
      puts 'FOUND'
      exits[robotloc][dir] = true
      robotloc = addvec(robotloc, directions[dir])

      pathstack << dir

      camefrom = oppdir[dir]

      return robotloc
    else
      raise "illegal response #{resp}"
    end
  end
  
  # if we get here, then all four directions yield nothing
  robotloc = topleveloldrobotloc
  pathstack.pop
  return nil
end

x = search(intcode, exits, robotloc, directions, statuses, camefrom, pathstack, oppdir)
p x
p pathstack
