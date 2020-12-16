lines = File.readlines(ARGV.shift, chomp: true)

def set_one_bit(number, bit_index, bit_value)
  bit_mask = ~(1 << bit_index)
  # puts "SET #{number}[#{bit_index}] = #{bit_value}"
  (number & bit_mask) | ((bit_value & 1) << bit_index)
end

x_locations = nil
mask_without_xs = nil
memory = {}
lines.each do |line|
  case line
  when /^mask = ([01X]+)$/
    mask = $1

    x_locations = mask.chars.map.with_index{|ch, i|35 - i if ch == 'X'}.compact
    mask_without_xs = mask.gsub(/X/, '0').to_i(2)
  when /^mem\[(\d+)\] = (\d+)$/
    input_address = $1.to_i
    value = $2.to_i

    (2**x_locations.length).times do |i|
      address = input_address | mask_without_xs
      x_locations.each_with_index do |b, n|
        address = set_one_bit(address, b, i[n])
      end
      memory[address] = value
      # puts "memory[#{address}] = #{value}"
    end

  else
    raise "could not determine type of line \"#{line}\""
  end
end

puts memory.values.sum
