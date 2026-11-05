require 'set'

DIRS = {
  'E' => [ 1,  0],
  'N' => [ 0,  1],
  'W' => [-1,  0],
  'S' => [ 0, -1],
}

def diradd(u, v)
  u.zip(v).map { |a, b| a + b }
end

DOORS = Set.new
def follow_dirs(str, curr_loc)
  str.chars.each do |dir_str|
    next_loc = diradd(curr_loc, DIRS[dir_str])

    DOORS.add( [curr_loc, next_loc].sort )
    curr_loc = next_loc
  end

  return curr_loc
end

# goofy
ifname = 'example_ans23.txt'

istring =
  File.read(ifname).chomp
       .gsub(/\^/, '{')
       .gsub(/\$/, '}')
       .gsub(/\|\)/, ',nil],')
       .gsub(/\|/, ',')
       .gsub(/\(/, ',=>{')
       .gsub(/\)/, '},')
       .gsub(/,+/, ',')
       .gsub(/,\]/, '}')
       .gsub(/([ENSW]+)/, '"\1"')

input = eval istring

p input
exit

def walk_tree(tree, curr_loc = [0, 0])
  tree.each do |chunk|
    case chunk
    when Array
      puts "#{chunk.inspect} is an array"
      curr_loc = walk_tree(chunk, curr_loc)
    when String
      puts "#{chunk.inspect} is a string"
      curr_loc = follow_dirs(chunk, curr_loc)
    end
  end

  curr_loc
end

walk_tree(input)
p DOORS
