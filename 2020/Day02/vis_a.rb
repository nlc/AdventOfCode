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
  printf("%-5s \033[1m%c\033[0m: % -24s", nums, char, string)
  print "\033[24D"
  last_index = 0
  indices.each_with_index do |index, i|
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
  print "\r\033[32C"
  if too_few
    print "\033[34mTOO FEW (#{count} < #{least})\033[0m"
  elsif too_many
    print "\033[31mTOO MANY (#{count} > #{most})\033[0m"
  else
    print "\033[32mVALID (#{count})\033[0m"
  end
  puts
end
puts total
