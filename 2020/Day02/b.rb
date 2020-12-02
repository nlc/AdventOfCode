total = 0
File.readlines('input.txt', chomp: true).each do |line|
  nums, letter, string = line.split

  indices = nums.split('-').map(&:to_i)
  char = letter.chars[0]

  num_matches =
    indices.count do |index|
      string[index - 1] == char
    end

  total += num_matches % 2
end
puts total
