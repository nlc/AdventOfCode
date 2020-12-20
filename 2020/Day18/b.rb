# Automaton for parsing out simple math expressions

def get_ranges(str)
  depth = 0
  paren_range_starts = []
  paren_ranges = {} # depth => [a..b, c..d, ...]

  number_range_start = nil
  number_ranges = []

  operator_indices = []

  str.chars.each_with_index do |ch, i|
    case ch
    when '('
      paren_range_starts[depth] = i
      depth += 1
    when ')'
      depth -= 1

      paren_ranges[depth] = [] unless paren_ranges.key? depth
      paren_ranges[depth] << (paren_range_starts[depth]..i)
    when /\d/
      if number_range_start.nil?
        number_range_start = i
      else
        number_ranges << number_range_start..i

        number_range_start = nil
      end
    when /[*+]/
      operator_indices << i
    end
  end

  [paren_ranges, number_ranges, operator_indices]
end

# Parse a "run" of symbols without parentheses
def parse_run
  nil
end

def parse(str)
  paren_ranges, number_ranges, operator_indices = get_ranges(str)

  p paren_ranges
  p number_ranges
  p operator_indices

  parens = paren_ranges.map do |paren_range|
    [:paren, paren_range]
  end

  numbers = number_ranges.map do |number_range|
    [:number, number_range]
  end

  operators = operator_indices.map do |operator_index|
    [:operator, operator_index]
  end

  # Interleave
  p parens + numbers + operators

  p paren_ranges
  p number_ranges
  p operator_indices

  max_depth = paren_ranges.keys.max

  # (0..max_depth).each do |depth|
  # end
end

sample_answers = [14, 51, 46, 1445, 669060, 23340]

File.readlines('sample.txt', chomp: true).each_with_index do |line, i|
  answer = parse(line)
  if answer == sample_answers[i]
    puts "\033[32m#{line} == #{answer}\033[0m"
  else
    puts "\033[31m#{line} != #{answer}\033[0m (#{sample_answers[i]})"
  end
end
