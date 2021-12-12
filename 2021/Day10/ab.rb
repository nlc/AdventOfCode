OPENS = ['(', '[', '{', '<'].freeze
CLOSES = [')', ']', '}', '>'].freeze
OPENS_FOR = CLOSES.zip(OPENS).to_h
SCORES = {')' => 3, ']' => 57, '}' => 1197, '>' => 25137}.freeze

def find_corrupt(l)
  stack = []
  l.chars.each_with_index do |ch, i|
    if OPENS.include? ch
      stack.push ch
    elsif CLOSES.include? ch
      unless stack.pop == OPENS_FOR[ch]
        return ch, i
      end
    end
  end

  nil
end

def day10a(input, verbose: false)
  max_l_length = input.map(&:length).max + 12
  format_str = "%#{max_l_length + 2}s: Error on \"%c\" at position% 3d"
  error_score =
    input.map do |line|
      ch, i = find_corrupt(line)
      unless ch.nil?
        line[i] = "\033[1;31m#{ch}\033[0m"
        puts format_str % ["\"#{line}\"", ch, i] if verbose
      end

      SCORES[ch]
    end.compact.inject(:+)

  error_score
end

def day10b(input, verbose: false)
  input.reject! do |line|
    find_corrupt(line)
  end

  
end

SAMPLE = true

fname = SAMPLE ? 'sample.txt' : 'input.txt'

input = File.readlines(fname, chomp: true)

answer_a = day10a(input, verbose: SAMPLE)
answer_b = day10b(input)

puts 'Day 10:'
puts "  Part A: #{answer_a}"
puts "  Part B: #{answer_b}"
