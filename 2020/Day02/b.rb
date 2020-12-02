total = 0
File.readlines('input.txt', chomp: true).each do |line|
  nums, letter, string = line.split

  least, most = nums.split('-').map(&:to_i)
  char = letter.chars[0]

  num_matches = 0

  num_matches += 1 if (string.chars[least-1] == char) && (string.chars[most - 1] != char)
  num_matches += 1 if (string.chars[least-1] != char) && (string.chars[most - 1] == char)

  total += 1 if num_matches == 1
end
puts total
