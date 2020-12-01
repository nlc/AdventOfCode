# [1518-09-07 23:52] Guard #619 begins shift
# [1518-08-20 00:15] wakes up
# [1518-06-11 00:53] falls asleep

require 'Date'

records = File.readlines("input.txt").map do |line|
  record = {}
  time, info = line.scan(/\[(.*)\] (.*)/).first
  record[:time] = DateTime.strptime(time, "%Y-%m-%d %H:%M").strftime("%s").to_i # lmao
  case info
  when /Guard/
    record[:guard] = info.match(/\d+/)[0].to_i
    record[:action] = :begins
  when /wakes/
    record[:action] = :wakes
  when /falls/
    record[:action] = :sleeps
  end

  record
end

records = records.sort_by{|record|record[:time]}

# records.each do |record|
#   puts "%s\t|\t#%s %s" % [:time, :guard, :action].map{|x|record[x].to_s}
# end

# Turns out that guards always wake as the last action of their shift

guards = {}

curr_guard = nil
records = records.map do |record|
  unless curr_guard
    curr_guard = record[:guard] || raise("ASDFASDF")
  end

  if record[:guard]
    curr_guard = record[:guard]
  else
    record[:guard] = curr_guard
  end

  unless guards[curr_guard]
    guards[curr_guard] = []
  end
  guards[curr_guard] << record[:time]

  record
end

guards.keys.each do |id|
  timestamps = guards[id]
  sleep_times = []
  wake_times = []

  sleep_histogram = [0] * 60
  total_sleeping_time = 0;

  state = :waking # Starts out awake
  last_timestamp = timestamps.shift
  
  timestamps.each do |timestamp|
    time_range = (last_timestamp...timestamp)

    unless time_range.size > 12 * 3600 # if timerange > 12 hr then it's a new day
      if state == :waking # Then waking period has just ended
        wake_times << time_range
        state = :sleeping
      elsif state == :sleeping # Then sleep has just ended
        sleep_times << time_range
        time_range.step(60).each do |moment|
          sleep_histogram[DateTime.strptime(moment.to_s, "%s").strftime("%M").to_i] += 1 #aaaaaaa
        end
        total_sleeping_time += time_range.size / 60.0
        state = :waking
      else
        raise("ASDFASDFASDF")
      end
    end

    last_timestamp = timestamp
  end

  if total_sleeping_time != sleep_histogram.sum then raise "#{total_sleeping_time} != #{sleep_histogram.sum}" end

  guards[id] = {wake_times: wake_times, sleep_times: sleep_times, total_sleeping_time: total_sleeping_time, sleep_histogram: sleep_histogram}
end

[guards.max_by{|k,v|v[:total_sleeping_time]}, guards.max_by{|k,v|v[:sleep_histogram].max}].each_with_index do |guard, i|
  guard_id = guard[0]
  guard_hist = guard[1][:sleep_histogram]
  guard_minute = guard_hist.index guard_hist.max

  puts "Part #{i + 1}:"
  puts "#{guard_id} * #{guard_minute} = #{guard_id * guard_minute}"
end

# Just for fun
total_histogram = [0] * 60
guards.each do |guard|
  guard[1][:sleep_histogram].each_with_index do |value, i|
    total_histogram[i] += value
  end
end
# scale = 50.0 / total_histogram.max.to_f
scale = 1

puts "Minute | Total | Histogram"
total_histogram.each_with_index do |value, i|
  puts "% 6d |% 6d | %s" % [i, value.to_i, "*" * (value * scale).to_i]
end
