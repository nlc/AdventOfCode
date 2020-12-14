# Had to derive the expression (N + z) % b = 0 -> N % b = -z % b
# I'm 99% sure that's valid
def effective_offset(offset, base)
  -offset % base
end

fname = ARGV.shift
buses =
  File.readlines(fname, chomp: true).last.split(',').map.with_index do |bus, offset|
    busi = bus.to_i
    [offset, busi, effective_offset(offset, busi)] if bus !~ /x/
  end.compact

buses.each do |offset, bus, eff_off| # ha ha
  puts "Bus #{'%3d' % bus} departs at time n#{offset > 0 ? " + #{offset}"  : ''}"
end

buses.each do |offset, bus, eff_off|
  mod_str = '%3d' % bus
  puts "(N + #{offset}) % #{mod_str} = 0   ->   N % #{mod_str} = -#{offset} % #{mod_str}   ->   N % #{mod_str} = #{eff_off}"
end

# Semi-empirical method
# find the offset and cycle length after each new cycle,
# then iterate by that much for finding the next one, etc.
sorted_buses =
  buses.sort_by do |offset, bus, eff_off|
    -bus # Order by largest modulo first
    # bus # Order by smallest modulo first
  end

_, cycle_length, cycle_offset = sorted_buses.first
puts cycle_length

# The below algorithm finds A solution to the system but not the SMALLEST
n = 0
sorted_buses[1..-1].each do |offset, bus, eff_off|
  n = cycle_offset
  while true
    break if n % bus == eff_off
    n += cycle_length
  end
  cycle_offset = n
  n += cycle_length
  while true
    break if n % bus == eff_off
    n += cycle_length
  end
  cycle_length = n - cycle_offset
end

puts n % buses.map{|bus|bus[1]}.inject(:*) # not EXACTLY sure why this works as I found it almost by accident
