def lrotate(arr, n)
  n %= arr.length
  arr[n..-1] + arr[0...n]
end

def rule(cups)
  # Chunk into:
  #   select | pickups | destination | rest
  # MUST ensure that select is first

  len = cups.length

  selected_value = cups[0]
  pickups = cups[1..3]
  rest = cups[4...len]

  destination_value = selected_value == 1 ? len : selected_value - 1
  while pickups.include?(destination_value)
    destination_value = destination_value == 1 ? len : destination_value - 1
  end
  destination_index = rest.index(destination_value)

  # Chunk rest into pre, dest, post
  upto_dest = rest[0..destination_index]
  post_dest = rest[(destination_index + 1)..-1]

  new_cups = [selected_value] + upto_dest + pickups + post_dest

  lrotate(new_cups, 1)
end

def after_1(arr)
  lrotate(arr, arr.index(1))[1..-1].join
end

require 'set'


def perform(n)
  input = '219748365'
  cups = input.chars.map(&:to_i) + ((input.length + 1)..n).to_a

  puts "cups = #{cups.inspect}"

  seen_configs = Set.new

  i = 0
  loop do
    cups = rule(cups)

    if seen_configs.include?(cups)
      puts "RECURRENCE AT #{i}"
      break
    end

    seen_configs.add(cups)

    i += 1
  end

  p cups
end

(9..20).each do |n|
  perform n
end
