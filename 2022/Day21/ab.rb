OPERATION_PATTERN = /^([a-z]{4}): ([a-z]{4}) ([\+\-\*\/]) ([a-z]{4})$/.freeze
CONSTANT_PATTERN = /^([a-z]{4}): ([0-9]+)$/.freeze

nodes = {}

fname = ARGV.shift || 'input.txt'

File.readlines(fname, chomp: true).each_with_index do |line, iline|
  case line
  when OPERATION_PATTERN
    match_data = line.match(OPERATION_PATTERN)
    node, left_child, operation, right_child = match_data.to_a[1..4]

    nodes[node] = { op: operation, lf: left_child, rt: right_child }
  when CONSTANT_PATTERN
    match_data = line.match(CONSTANT_PATTERN)
    node, value = match_data.to_a[1..2]

    nodes[node] = { va: value.to_i }
  else
    raise "No pattern matches line #{iline}: #{line.inspect}"
  end
end

def evaluate(node, nodes)
  node_data = nodes[node]

  if node_data.key?(:va)
    return node_data[:va]
  else
    op = node_data[:op]
    lf_value = evaluate(node_data[:lf], nodes)
    rt_value = evaluate(node_data[:rt], nodes)

    case op
    when '+'
      lf_value + rt_value
    when '-'
      lf_value - rt_value
    when '*'
      lf_value * rt_value
    when '/'
      lf_value / rt_value
    end
  end
end

def human_evaluate(node, human_input, nodes)
  node_data = nodes[node]

  if node_data.key?(:va)
    if node == 'humn'
      human_input
    else
      node_data[:va]
    end
  else
    op = node_data[:op]
    lf_value = human_evaluate(node_data[:lf], human_input, nodes)
    rt_value = human_evaluate(node_data[:rt], human_input, nodes)

    if node == 'root'
      lf_value - rt_value
    else
      case op
      when '+'
        lf_value + rt_value
      when '-'
        lf_value - rt_value
      when '*'
        lf_value * rt_value
      when '/'
        lf_value / rt_value
      end
    end
  end
end

def differential_human_evaluate(node, human_input, nodes)
  y1 = human_evaluate(node, human_input, nodes)
  y2 = human_evaluate(node, human_input + 1, nodes)

  y2 - y1
end

def day21a(nodes)
  evaluate('root', nodes)
end

def day21b(nodes)
  min_guess = 0
  max_guess = 1000000000000000

  # last_guess = 123
  # last_result = human_evaluate('root', last_guess, nodes)

  loop do
    guess = ((min_guess + max_guess) / 2.0).to_i
    result = human_evaluate('root', guess, nodes)

    # puts "#{guess} => #{result}"

    # As written this needs to be turned around for sample vs input!
    # Something to do with whether the 'humn' node is on the left or the right,
    # I would bet.
    if result > 0
      min_guess = guess
    elsif result < 0
      max_guess = guess
    else
      return guess - 1
    end
  end
end

puts 'Day 10:'
puts "  Part A: #{day21a(nodes)}"
puts "  Part B: #{day21b(nodes)}"

