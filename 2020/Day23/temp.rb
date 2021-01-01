require 'date'

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
  idx = arr.index(1)
  arr[(idx + 1) % arr.length] * arr[(idx + 2) % arr.length]
end


input = '219748365'

cups = input.chars.map(&:to_i)
cups += ((cups.max + 1)..(1000000 + cups.max + 1 - cups.length)).to_a

pbwidth = 50
t1 = DateTime.now
10000000.times do |i|
  cups = rule(cups)

  if i == 0
    t2 = DateTime.now
    File.open('_day23_results.txt', 'a') do |output|
      output.printf("%s: %d / 10000000 ( %.3f %% ) | ETA: %s\n", t2.to_s, 0, 0, '?')
      output.flush
    end
  elsif i % 250 == 0
    prog= i.to_f / 10000000

    t2 = DateTime.now
    dt = t2 - t1

    total_time_estimate = dt / prog
    eta = t1 + total_time_estimate
    eta_str = eta.to_s

    pct = prog * 100

    File.open('_day23_results.txt', 'a') do |output|
      output.printf("%s: %d / 10000000 ( %.3f %% ) | ETA: %s\n", t2.to_s, i, pct, eta_str)
      output.flush
    end
  end
end

soln = after_1(cups)

File.open('_day23_results.txt', 'a') do |output|
  output.puts
  output.puts cups.inspect
  output.puts
  output.puts "\033[2K\r#{soln}"
end
