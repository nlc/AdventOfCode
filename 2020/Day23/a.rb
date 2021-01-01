def lrotate(arr, n)
  n %= arr.length
  arr[n..-1] + arr[0...n]
end

def rule(cups)
  # Chunk into:
  #   select | pickups | destination | rest
  # MUST ensure that select is first

  selected_value = cups[0]
  pickups = cups[1..3]
  rest = cups[4...9]

  destination_value = selected_value == 1 ? 9 : selected_value - 1
  while pickups.include?(destination_value)
    destination_value = destination_value == 1 ? 9 : destination_value - 1
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


input = ARGV.shift || raise('Usage: ruby a.rb <input configuration>')

cups = input.chars.map(&:to_i)

100.times do |i|
  cups = rule(cups)
end

puts after_1(cups)
