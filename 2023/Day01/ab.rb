DIGIT_NAMES = %w(zero one two three four five six seven eight nine)
DIGIT_TRANSFORM = DIGIT_NAMES.zip( (0...(DIGIT_NAMES.length)).to_a.map(&:to_s) ).to_h

fname = ARGV.shift || 'input.txt'

def day01a(lines)
  lines.sum do |line|
    digits = line.scan(/\d/).flatten

    (digits.first + digits.last).to_i
  end
end

def day01b(lines)
  lines.sum do |line|
    digits = line.scan(/(?=(\d|#{DIGIT_NAMES.join('|')}))/).flatten

    first = DIGIT_TRANSFORM[digits.first] || digits.first
    last = DIGIT_TRANSFORM[digits.last] || digits.last

    (first + last).to_i
  end
end

lines = File.readlines(fname, chomp: true)

puts 'Day 01:'
puts "  Part A: #{day01a(lines)}"
puts "  Part B: #{day01b(lines)}"
