instructions = File.readlines('input.txt', chomp: true).map(&:split).map{ |cmd, val| [cmd, val.to_i] }

x = 1
clock = 1

stops = [20, 60, 100, 140, 180, 220]
carrying = nil

results = []

linei = 0
cursori = 0

display = Array.new(6) { Array.new(40) { ' ' } }

while clock <= 240
  if (x - cursori).abs <= 1
    display[linei][cursori] = '#'
  end
  cursori += 1

  if cursori >= 40
    linei += 1
    cursori = 0
  end

  if carrying.nil?
    cmd, val = instructions.shift
    if cmd == 'addx'
      carrying = val
    end
  else
    x += carrying
    carrying = nil
  end
  clock += 1

  if stops.any? && clock >= stops.first
    check_cycle = stops.shift

    results << check_cycle * x
  end
end

puts 'Day 10:'
puts "  Part A: #{results.sum}"
puts "  Part B: \n#{display.map{ |line| '    ' + line.join }.join("\n")}"
