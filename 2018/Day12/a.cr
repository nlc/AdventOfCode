initial_state = [] of Char
rules = {} of String => Char
neighborhood_size = 0
iterations = 200

# initialize
File.read_lines("input.txt").each_with_index do |line, i|
  if i == 0
    initial_state = line.gsub(/^.* |\n/, "").chars
  elsif i == 1
    # do nothing
  else
    matches = line.scan(/^(.*) => (.*)$/)
    # puts matches.inspect
    neighborhood_size = matches[0][1].size
    rules[matches[0][1]] = matches[0][2][0]
  end
end

# pad to the left and right
padding_size = (2 * iterations).to_i
padding = Array.new(padding_size, '.')
extra_padding_size = Int64.new(neighborhood_size / 2)
extra_padding = Array.new(extra_padding_size, '.')

initial_state = padding + initial_state + padding
state = initial_state.clone

# puts "P1"
# puts "#{state.size} #{iterations}"

iterations.times do |i|
  inner_state = [] of Char
  state.each_cons(neighborhood_size).each_with_index do |chunk|
    inner_state << rules[chunk.join]
  end
  state = extra_padding + inner_state + extra_padding
  # print state.join.gsub(/./, {"#" => "1 ", "." => "0 "})
end

result = Int64.new(0)

puts Int64.new(50000000000)

state.each_with_index do |char, i|
  if char == '#'
    result += (Int64.new(i) - Int64.new(padding_size)) + Int64.new(50000000000) - Int64.new(iterations)
    puts result
  end
end
puts result
