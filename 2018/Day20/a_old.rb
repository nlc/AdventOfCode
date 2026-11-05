require 'set'

ifname = 'example_ans23.txt'

DIRS = {
  'E' => [ 1,  0],
  'N' => [ 0,  1],
  'W' => [-1,  0],
  'S' => [ 0, -1],
}

def diradd(u, v)
  u.zip(v).map { |a, b| a + b }
end

inputstr = File.read(ifname)[1...-2] # remove first and last

DOORS = Set.new
def walk_tree(instructions, depth = 0, curr_loc = [0, 0])
  puts "depth = #{depth}"

  return if instructions.length.zero?

  dirs, after = instructions.match(/([ENWS]*)(.*)/).to_a.drop(1)

  dirs.chars.each do |dc|
    next_loc = diradd(curr_loc, DIRS[dc])
    DOORS.add( [curr_loc, next_loc].sort ) # careful
    curr_loc = next_loc
  end

  puts "dirs = #{dirs}"
  puts "rest = #{after}"

  loop do
    break if after.length.zero?

    first = after[0]
    rest = after[1..]

    case first
    when /\(/
      puts "start branch"
      after = walk_tree(rest, depth + 1, curr_loc)
    when /\|/
      puts "alternative branch"
    when /\)/
      puts "end branch"
      return after
    end

    after = rest
  end
end

walk_tree(inputstr)

puts DOORS
