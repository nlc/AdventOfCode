# We'll need a more detailed state representation for cart_elements
# A cart can be moving in one of four directions and have one of three internal
# states: GO_LEFT_NEXT, GO_STRAIGHT_NEXT, or GO_RIGHT_NEXT.
# To keep it simple, two bits for direction + two bits for state = four bits,
# conveniently representable as a hex digit.
# Let the low-order bits be state and the high-order bits be direction.
# 0,1,2,3 <-> right, up, left, down
# +
# 0,4,8,C <-> NONE, left_next, straight_next, right_next
# 0 - NONE
# 1 - NONE
# 2 - NONE
# 3 - NONE
# 4 - moving RIGHT and will turn LEFT     next
# 5 - moving UP    and will turn LEFT     next
# 6 - moving LEFT  and will turn LEFT     next
# 7 - moving DOWN  and will turn LEFT     next
# 8 - moving RIGHT and will turn STRAIGHT next
# 9 - moving UP    and will turn STRAIGHT next
# A - moving LEFT  and will turn STRAIGHT next
# B - moving DOWN  and will turn STRAIGHT next
# C - moving RIGHT and will turn RIGHT    next
# D - moving UP    and will turn RIGHT    next
# E - moving LEFT  and will turn RIGHT    next
# F - moving DOWN  and will turn RIGHT    next

track_elements = %w[ - | / \\ + ]
cart_elements = %w[ > ^ < v ]
empty = [' ']

# Headings
HEAD_EAST = 0
HEAD_NORTH = 1
HEAD_WEST = 2
HEAD_SOUTH = 3

# Turns
TURN_STRAIGHT = 0
TURN_LEFT = 1
TURN_BACK = 2
TURN_RIGHT = 3

def heading_name(heading)
  ["EAST", "NORTH", "WEST", "SOUTH"][heading]
end

def heading(cart)
  {
    '>' => HEAD_EAST,
    '^' => HEAD_NORTH,
    '<' => HEAD_WEST,
    'v' => HEAD_SOUTH,
  }[cart]
end

def turn_name(direction)
  ["STRAIGHT", "LEFT", "BACK", "RIGHT"][direction]
end

def turn(cart, direction)
  (cart + direction) % 4
end

def next_turn(turn)
  [TURN_RIGHT, TURN_STRAIGHT, nil, TURN_LEFT][turn]
end 

the_turn = TURN_LEFT
10.times do
  puts turn_name(the_turn)
  the_turn = next_turn(the_turn)
end

# [HEAD_EAST, HEAD_NORTH, HEAD_WEST, HEAD_SOUTH].each do |heading|
#   [TURN_STRAIGHT, TURN_LEFT, TURN_BACK, TURN_RIGHT].each do |direction|
#     puts "#{heading_name(heading)} turns #{turn_name(direction)} to #{heading_name(turn(heading, direction))}; next turn is #{turn_name(next_turn(turn(heading, direction))) rescue "NONE"}"
#   end
# end

# read file
grid = File.readlines("test.txt").map{|line|line.chars}
carts = []

grid.each_with_index do |line, i|
  line.each_with_index do |char, j|
    if cart_elements.include? char
      carts << [i, j, heading(char), TURN_LEFT]
    end
  end
end

cont = true

while cont
  carts.each do 
    
  end
end
