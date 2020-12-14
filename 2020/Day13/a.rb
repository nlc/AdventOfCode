fname = 'input.txt'
data = File.readlines(fname, chomp: true)

earliest_time = data.first.to_i
bus_times = data.last.split(',').grep(/^\d+$/).map(&:to_i)

nearest_departures =
  bus_times.map do |bus_time|
    iteration = (earliest_time / bus_time) + 1
    actual_time = iteration * bus_time
    diff = actual_time - earliest_time
    [bus_time, diff]
  end.to_h

bus_number, wait_time = nearest_departures.min_by { |_k, v| v }
puts "Wait #{wait_time} minutes for Bus ##{bus_number} --> #{bus_number * wait_time}"
