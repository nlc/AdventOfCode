def crane(orig_stacks, instructions, reverse)
  stacks = orig_stacks.map(&:dup)

  instructions.each_with_index do |instruction, i|
    amount, target, destination = instruction.chomp.match(/move (\d+) from (\d) to (\d)/).to_a.drop(1).map(&:to_i)

    if stacks[target].any?
      carry = stacks[target].pop(amount)
      carry.reverse! if reverse
      stacks[destination] += carry
    else
      raise 'miss'
    end

    # print "\033[2J\033[H"
    # puts "------------ #{i} -------------"
    # stacks.each do |k, v|
    #   puts "#{k} | #{v}"
    # end
    # sleep 0.1
  end

  stacks[1..-1].map(&:last).join
end

def day05a(orig_stacks, instructions)
  crane(orig_stacks, instructions, true)
end

def day05b(orig_stacks, instructions)
  crane(orig_stacks, instructions, false)
end

orig_stacks = Array.new(10)
File.readlines('christmas_message_layout.txt').each_with_index do |line, i|
  orig_stacks[i + 1] = line.chomp.chars
end

instructions = File.readlines('christmas_message_instructions.txt')

puts 'Day 05:'
puts "  Part A: #{day05a(orig_stacks, instructions)}"
puts "  Part B: #{day05b(orig_stacks, instructions)}"
