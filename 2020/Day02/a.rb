total = 0
File.readlines('input.txt', chomp: true).each do |line|
  nums, letter, string = line.split

  least, most = nums.split('-').map(&:to_i)
  char = letter.chars[0]
  total += 1 if (least..most).include? string.count(char)
end
puts total
