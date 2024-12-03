input = File.read('input.txt')

def day03a(input)
  input.scan(/mul\((\d+,\d+)\)/).to_a.map{|e|e[0].split(',').map(&:to_i).inject(&:*)}.sum
end

def day03b(input)
  enabled = true
  sum = 0

  input.scan(/(do(n't)?)|mul\((\d+,\d+)\)/).map{|e|e.compact[0]}.each do |e|
    case e
    when 'do'
      enabled = true
    when 'don\'t'
      enabled = false
    when /\d+,\d+/
      sum += e.split(',').map(&:to_i).inject(&:*) if enabled
    else
      raise "malformed input #{e.inspect}"
    end
  end

  sum
end

puts 'Day 03:'
puts "  Part A: #{day03a input}"
puts "  Part B: #{day03b input}"
