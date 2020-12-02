def slowprint(str)
  str.chars.each do |char|
    print char
    sleep 0.05
  end
end

total = 0
File.readlines('input.txt', chomp: true).each do |line|
  nums, letter, string = line.split

  least, most = nums.split('-').map(&:to_i)
  char = letter.chars[0]

  count = string.count(char)
  too_few = count < least
  too_many = count > most
  found = !too_few && !too_many
  total += 1 if found

  indices = (0...string.length).to_a.select { |i| string[i] == char }
  slowprint sprintf("%-5s \033[1m%c\033[0m: %s", nums, char, string)
  print "\033[#{string.length}D"
  last_index = 0
  indices.each_with_index do |index, i|
    sleep 0.2
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
  sleep 0.4
  print "\r\033[32C"
  if too_few
    slowprint "\033[34mTOO FEW (#{count} < #{least})\033[0m"
  elsif too_many
    slowprint "\033[31mTOO MANY (#{count} > #{most})\033[0m"
  else
    slowprint "\033[32mVALID (#{count})\033[0m"
  end
  puts
end
puts total
