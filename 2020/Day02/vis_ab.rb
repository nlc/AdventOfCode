$slowprint_sleep = 0.02
$scan_sleep = 0.1
$pause_sleep = 0.2

def slowprint(str)
  str.to_s.chars.each do |char|
    print char
    sleep $slowprint_sleep
  end
end

part1_total = 0
part2_total = 0
File.readlines('input.txt', chomp: true).each_with_index do |line, t|
  nums, letter, string = line.split

  least, most = nums.split('-').map(&:to_i)
  char = letter.chars[0]

  count = string.count(char)
  too_few = count < least
  too_many = count > most
  found = !too_few && !too_many
  part1_total += 1 if found

  indices = (0...string.length).to_a.select { |i| string[i] == char }
  slowprint sprintf("%-5s \033[1m%c\033[0m: %s", nums, char, string)
  print "\033[#{string.length}D"
  last_index = 0
  indices.each_with_index do |index, i|
    sleep $scan_sleep
    dx = index - last_index
    if dx > 0
      print "\033[#{dx}C"
    end

    i += 1
    if i < least
      print "\033[34m"
    elsif i > most
      print "\033[31m"
    else
      print "\033[32m"
    end

    print char
    print "\033[0m"
    print "\033[D"

    last_index = index
  end
  sleep $pause_sleep
  print "\r\033[32C"
  if too_few
    slowprint "\033[34mTOO FEW (#{count} < #{least})\033[0m"
  elsif too_many
    slowprint "\033[31mTOO MANY (#{count} > #{most})\033[0m"
  else
    slowprint "\033[32mVALID (#{least} <= #{count} <= #{most})\033[0m"
  end

  i1 = least - 1
  i2 = most - 1
  num_matches =
    [i1, i2].count do |index|
      string[index] == char
    end
  print "\r\033[56C"
  print "\033[2m"
  slowprint string
  print "\033[0m"
  print "\033[#{string.length}D"

  print "\r\033[#{56 + i1}C"
  sleep $pause_sleep
  print "\033[1m#{string[i1]}\033[0m"
  print "\r\033[#{56 + i2}C"
  sleep $pause_sleep
  print "\033[1m#{string[i2]}\033[0m"

  sleep $pause_sleep
  print "\r\033[78C"
  if num_matches == 0
    slowprint "\033[34mZERO\033[0m"
  elsif num_matches == 2
    slowprint "\033[31mTWO\033[0m"
  else
    part2_total += 1
    slowprint "\033[32mONE\033[0m"
  end

  puts

  factor = 0.75
  case t
  when 3..500
    $slowprint_sleep *= factor
    $scan_sleep *= factor
    $pause_sleep *= factor
  when 500...996
    $slowprint_sleep /= factor
    $scan_sleep /= factor
    $pause_sleep /= factor
  when 995
    $slowprint_sleep = 0.02
    $scan_sleep = 0.1
    $pause_sleep = 0.2
  end

end

$slowprint_sleep = 0.05
$scan_sleep = 0.2
$pause_sleep = 0.5

sleep 1
slowprint "\r\033[32C"
slowprint '-' * 22
slowprint "\r\033[78C"
slowprint '-' * 5
puts
slowprint "\033[1mTOTALS:\033[0m"
sleep $pause_sleep
slowprint "\r\033[32C"
slowprint part1_total
sleep $pause_sleep
slowprint "\r\033[78C"
slowprint part2_total
sleep 1
puts
puts 'done'
