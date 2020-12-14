fname = 'input.txt'
buses =
  File.readlines(fname, chomp: true).last.split(',').map.with_index do |bus, i|
    [i, bus.to_i] if bus !~ /x/
  end.compact

buses.each do |i, bus|
  puts "Bus #{'%3d' % bus} departs at time n#{i > 0 ? " + #{i}"  : ''}"
end
