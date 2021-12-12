OPENS = ['(', '[', '{', '<'].freeze
CLOSES = [')', ']', '}', '>'].freeze
OPENS_FOR = CLOSES.zip(OPENS).to_h
CLOSES_FOR = OPENS.zip(CLOSES).to_h
SCORES_A = {')' => 3, ']' => 57, '}' => 1197, '>' => 25137}.freeze
SCORES_B = {')' => 1, ']' => 2, '}' => 3, '>' => 4}.freeze

def day10(input, verbose: false)
  max_length = input.map(&:length).max + 12
  error_score = 0
  completion_scores = []

  input.each_with_index do |line, l|
    stack = []
    has_error = false
    line.chars.each_with_index do |ch, i|
      if OPENS.include? ch
        stack.push ch
      elsif CLOSES.include? ch
        expected = CLOSES_FOR[stack.pop]
        unless ch == expected
          error_score += SCORES_A[ch]
          has_error = true

          if verbose
            puts "\033[2;31mParse error (\033[0m#{FNAME}:#{l}:#{i}\033[0m\033[2;31m): " +
                 "expected \"\033[0;1m#{expected}\033[0m\033[2;31m\", " +
                 "found \"\033[0;1m#{ch}\033[0m\033[2;31m\"\033[0m"
          end

          next
        end
      end
    end

    unless has_error
      closers = stack.reverse.map{ |ch| CLOSES_FOR[ch] }
      completion_scores <<
        closers.reduce(0) do |sum, closer|
          sum * 5 + SCORES_B[closer]
        end

      if verbose
        puts "\033[1m#{line}\033[0;2m#{closers.join}\033[0m"
      end
    end
  end

  middle_score = completion_scores.sort[completion_scores.length / 2]
  [error_score, middle_score]
end

SAMPLE = true

FNAME = SAMPLE ? 'sample.txt' : 'input.txt'

input = File.readlines(FNAME, chomp: true)

answer_a, answer_b = day10(input, verbose: SAMPLE)

puts 'Day 10:'
puts "  Part A: #{answer_a.inspect}"
puts "  Part B: #{answer_b.inspect}"
