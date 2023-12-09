def day09a(lines)
  lines.map do |line|
    rows = [line]
    until line.all? { |item| item == 0 }
      rows << line = line[1..].zip(line[0...]).map{|a,b|a-b}
    end
    rows.sum(&:last)
  end.sum
end

def day09b(lines)
  day09a(lines.map(&:reverse))
end

fname = ARGV.shift || 'input.txt'
lines = File.readlines(fname, chomp: true).map{|line|line.split(/\s+/).map(&:to_i)}

puts 'Day 09:'
puts "  Part A: #{day09a(lines)}"
puts "  Part B: #{day09b(lines)}"
