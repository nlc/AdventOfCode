fname = ARGV.shift || 'input.txt'
input = File.readlines(fname, chomp: true)

target_row = ARGV.shift&.to_i || 2_000_000

def manhattan(xy1, xy2)
  xy1.zip(xy2).map { |e1, e2| (e2 - e1).abs }.sum
end

def slice_width(r, dy) # width of slice of circle of radius r at offset of dy from center
  2 * (r - dy.abs) + 1
end

def overlap?(ra, rb)
  ra.cover?(rb.begin) || ra.cover?(rb.end) || rb.cover?(ra.begin) || rb.cover?(ra.end)
end

def combine_2_ranges(ra, rb)
  if ra.cover?(rb)
    ra
  elsif rb.cover?(ra)
    rb
  elsif ra.cover?(rb.begin) || rb.cover?(ra.end)
    (ra.begin)..(rb.end)
  elsif rb.cover?(ra.begin) || ra.cover?(rb.end)
    (rb.begin)..(ra.end)
  else
    [ra, rb]
  end
end

def exclusion_at_row(sensor, max_dist, row)
  sensor_x, sensor_y = sensor
  width_at_row = slice_width(max_dist, row - sensor_y)

  wing_at_row = (width_at_row - 1) / 2

  exclusion_begin, exclusion_end = [sensor_x - wing_at_row, sensor_x + wing_at_row]

  (exclusion_begin..exclusion_end) if exclusion_begin <= exclusion_end
end

def combine_n_ranges(ranges)
  return [] if ranges.empty?

  working_range = ranges.shift

  islands = []

  ranges.each do |range|
    result = combine_2_ranges(working_range, range)

    case result
    in Array # not overlapping
      island, working_range = result
      islands << island
    in Range # combined into one
      working_range = result
    end
  end
  islands << working_range

  islands
end

def day15a(sensor_beacons, sensor_max_dists, target_row)
  exclusions_at_row =
    sensor_max_dists.map do |sensor, max_dist|
      exclusion_at_row(sensor, max_dist, target_row)
    end.compact.sort_by do |range|
      range.begin
    end

  combined_ranges = combine_n_ranges(exclusions_at_row)

  beacons_on_target_row = sensor_beacons.map { |sensor, beacon| beacon }.select { |beacon| beacon[1] == target_row }.uniq

  spaces_without_beacon =
    combined_ranges.sum do |range|
      contained_beacons = beacons_on_target_row.select { |beacon| range.cover?(beacon[0]) }

      range.size - contained_beacons.length
    end

  spaces_without_beacon
end

def day15b(sensor_beacons, sensor_max_dists)
  # FIXME: this probably doesn't handle (literal) edge cases
  (0..4_000_000).each do |current_row|
    print "\r\033[2K#{current_row} / 4000000 (#{100 * current_row / 4_000_000.0}%)"
    exclusions_at_row =
      sensor_max_dists.map do |sensor, max_dist|
        exclusion_at_row(sensor, max_dist, current_row)
      end.compact.sort_by do |range|
        range.begin
      end

    combined_ranges = combine_n_ranges(exclusions_at_row)

    ranges_in_area = combined_ranges.select { |range| overlap?(0..4_000_000, range) }

    if ranges_in_area.length > 1
      x = ranges_in_area.first.end + 1
      y = current_row

      print "\r\033[2K"
      break x * 4000000 + y
    end
  end
end



sensor_beacons =
  input.map do |line|
    sensor_x, sensor_y, beacon_x, beacon_y = line.match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/).to_a.drop(1).map(&:to_i)

    raise "Unable to parse input #{line.inspect}!" if [sensor_x, sensor_y, beacon_x, beacon_y].any?(&:nil?)

    [[sensor_x, sensor_y], [beacon_x, beacon_y]]
  end.to_h

sensor_max_dists =
  sensor_beacons.map do |sensor, beacon|
    dist = manhattan(sensor, beacon)

    [sensor, dist]
  end.to_h

puts "Day 15:"
puts "  Part A: #{day15a(sensor_beacons, sensor_max_dists, target_row)}"
puts "  Part B: #{day15b(sensor_beacons, sensor_max_dists)}"



# puts "total length of #{combined_ranges.inspect} = #{combined_ranges.sum(&:size)}"

# num_beacons_on_target_row = sensor_beacons.map { |sensor, beacon| beacon }.select { |beacon| beacon[1] == target_row }.uniq.count
# 
# # p sensor_beacons[[8, 7]]
# # (-3..18).each{|i|puts "impact of sensor at [8, 7] on line #{i}: #{exclusion_at_row([8, 7], sensor_max_dists[[8, 7]], i)}"}
# 
# puts
# p with_overlaps
# p with_overlaps.first.size - num_beacons_on_target_row
