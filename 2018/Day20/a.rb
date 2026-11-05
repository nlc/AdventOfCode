# d = 0; s.chars.map { |c| t = [c, d]; d += ({ '(' => 1, ')' => -1 }[c] || 0); t }

DIRS = {
  'E' => [ 1,  0],
  'N' => [ 0,  1],
  'W' => [-1,  0],
  'S' => [ 0, -1],
}

def diradd(u, v)
  u.zip(v).map { |a, b| a + b }
end

class LinkedNode
  attr_accessor :loc, :children, :follower
  def initialize(loc = nil)
    @loc = loc
    @children = []
    @follower = nil
  end

  def follow(loc = nil)
    raise 'error' unless @follower.nil?
    @follower = LinkedNode.new(loc)
  end
end

ifname = 'example_ans23.txt'
root = LinkedNode.new([0, 0])
curr_node = root

input = File.read(ifname).chomp.chars

until input.length.zero? do
  ch, *rest = input

  case ch
  when /[ENWS]/
    next_loc = diradd(curr_node.loc, DIRS[ch])
    curr_node.loc = next_loc
    # curr_node = curr_node.follow(next_loc)
  when /\(/
    curr_node.children
  when /\)/
    return nil
  when /\|/
    return curr_node
  end

  input = rest
end

p root
p curr_node
