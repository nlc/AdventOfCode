input = File.readlines('input.txt').map(&:chars)

ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

def day03a(input)
  input.map do |line|
    first_half = line[0...(line.length/2)]
    second_half = line[(line.length/2)..-1]

    common_letter = (first_half & second_half).first

    ALPHABET.index(common_letter) + 1
  end.sum
end

def day03b(input)
  input.each_slice(3).map do |lines|
    common_letter = lines.reduce(:&).first

    ALPHABET.index(common_letter) + 1
  end.sum
end

puts 'Day 03:'
puts "  Part A: #{day03a(input)}"
puts "  Part B: #{day03b(input)}"
