def get_lexemes(str)
  str.strip!

  lexemes = str.scan(/\d+|[)(]|[*+]/)

  matching_parens = {}

  last_open = {}

  depth = 0
  lexemes.each_with_index do |lexeme, i|
    if lexeme =~ /\(/
      last_open[depth] = i
      depth += 1
    elsif lexeme =~ /\)/
      depth -= 1
      matching_parens[last_open[depth]] = i
    end
  end

  [lexemes, matching_parens]
end

def parse(str)
  depth = 0
  result = 0

  run = []

  # puts "parsing #{str}"

  lexemes, matching_parens = get_lexemes(str)

  i = 0
  while i < lexemes.length
    lexeme = lexemes[i]
    case lexeme
    when /\d+/
      run << lexeme
    when /\(/
      ending = matching_parens[i]
      run << parse(lexemes[(i+1)..(ending-1)].join)
      i = ending
    when /\)/
      nil
    when /[*+]/
      run << lexeme
    else
      raise "Unknown lexeme \"#{lexeme}\""
    end
    i += 1
  end

  %w[+ *].each do |operator|
    while (idx = run.index operator)
      # puts "run = #{run.inspect}"
      leftidx = [idx - 1, 0].max
      rightidx = idx + 1

      leftarg = run[leftidx].to_s
      rightarg = run[rightidx].to_s

      raise 'oh no' if leftarg !~ /^\d+$/ || rightarg !~ /^\d+$/

      component_string = leftarg + operator + rightarg
      # puts "eval(#{component_string})"
      parsed_component = eval(component_string).to_s

      run =
        if idx == 1
          [parsed_component] + run[(rightidx + 1)..-1]
        else
          run[0..(leftidx - 1)] + [parsed_component] + run[(rightidx + 1)..-1]
        end

      run.map!(&:to_s)
    end
  end

  run.first.to_i
end

# sample_answers = [14, 51, 46, 1445, 669060, 23340]
#
# File.readlines('sample.txt', chomp: true).each_with_index do |line, i|
#   answer = parse(line)
#   if answer == sample_answers[i]
#     puts "\033[32m#{line} == #{answer}\033[0m"
#   else
#     puts "\033[31m#{line} != #{answer}\033[0m (#{sample_answers[i]})"
#   end
# end

sum = 0
File.readlines('input.txt', chomp: true).map do |line|
  sum += parse(line)
end

puts "\033[1m#{sum}\033[0m"
