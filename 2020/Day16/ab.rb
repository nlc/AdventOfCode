# Print a reconstruction of the input data to see if it matches
def test_output(rules, your_ticket, nearby_tickets)
  rules.each do |name, ranges|
    puts "#{name}: #{ranges.first.first}-#{ranges.first.last} or #{ranges.last.first}-#{ranges.last.last}"
  end

  puts
  puts 'your ticket:'
  puts your_ticket.join(',')

  puts
  puts 'nearby tickets:'
  nearby_tickets.each do |nearby_ticket|
    puts nearby_ticket.join(',')
  end
end

def matches_any_rule?(value, rules)
  rules.any? do |_name, ranges|
    ranges.first.include?(value) || ranges.last.include?(value)
  end
end

def part_a(rules, your_ticket, nearby_tickets)
  bad_values = []
  nearby_tickets.each do |nearby_ticket|
    nearby_ticket.each do |value|
      bad_values << value unless matches_any_rule?(value, rules)
    end
  end
  bad_values.sum
end

def good_tickets(nearby_tickets, rules)
  nearby_tickets.select do |nearby_ticket|
    nearby_ticket.all? do |value|
      matches_any_rule?(value, rules)
    end
  end
end

# return an array of which field could correspond to which column
def column_candidates(nearby_tickets, rules)
  rows = good_tickets(nearby_tickets, rules)
  num_columns = rows.first.length

  columns =
    num_columns.times.map do |i|
      rows.map{|nearby_ticket|nearby_ticket[i]}
    end

  candidates =
    rules.map do |name, ranges|
      (0...columns.length).to_a.select do |i|
        # does every element of the column match the rule
        column = columns[i]
        column.all? do |value|
          ranges.first.include?(value) || ranges.last.include?(value)
        end
      end
    end
end

# figure out which columns have only one possibility and remove that index from the others
def reduce_candidates(columns)
  if columns.any?{|column|column.length == 0}
    raise 'Ran out of candidates!'
  end

  fixed_columns = columns.select{|column|column.length == 1}
  if fixed_columns.length == 0
    raise 'Simple reduction ain\'t gonna cut it!'
  end

  taken_indices = fixed_columns.flatten

  columns.map do |column|
    if column.length > 1
      column - taken_indices
    else
      column
    end
  end
end

def part_b(rules, your_ticket, nearby_tickets)
  new_candidates = column_candidates(nearby_tickets, rules)
  candidates = nil

  until new_candidates == candidates
    candidates = new_candidates
    new_candidates = reduce_candidates(candidates)
  end

  field_to_column = rules.keys.zip(candidates.flatten).to_h
  p field_to_column

  field_to_column.select{|k, _v|k=~/^departure/}.map{|_k, v|your_ticket[v]}.inject(:*)
end

fname = ARGV.shift
if fname.nil?
  puts 'Usage: ruby a.rb <input file name>'
  exit
end

rules = {}
your_ticket = []
nearby_tickets = []

mode = :rules
File.readlines(fname, chomp: true).each do |line|
  case mode
  when :rules
    if line == ''
      mode = :your_ticket
    else
      name, rule_str = line.split(': ')
      rule_range_strs = rule_str.split(' or ')
      rule_ranges =
        rule_range_strs.map do |rule_range_str|
          Range.new(*(rule_range_str.split('-').map(&:to_i)))
        end
      rules[name] = rule_ranges
    end
  when :your_ticket
    if line == ''
      mode = :nearby_tickets
    elsif line != 'your ticket:'
      your_ticket = line.split(',').map(&:to_i)
    end
  when :nearby_tickets
    if line != 'nearby tickets:'
      nearby_tickets << line.split(',').map(&:to_i)
    end
  else
    raise "Bad mode #{mode}"
  end
end

puts part_a(rules, your_ticket, nearby_tickets)
puts part_b(rules, your_ticket, nearby_tickets)
