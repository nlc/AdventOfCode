fname = ARGV.shift || 'input.txt'

lines = File.readlines(fname, chomp: true)

data =
  lines.map do |line|
    id, handfuls = line.match(/Game (\d+): (.*)/).to_a.drop(1)

    [
      id.to_i,
      handfuls.split(/; */).map do |handful|
        %w[red green blue].map do |color|
          handful.match(/\d+ #{color}/)&.to_a&.first.to_i
        end
      end
    ]
  end

def day02a(data)
  data.select do |id, handfuls|
    handfuls.transpose.map(&:max).zip([12, 13, 14]).all? { |a, b| a <= b }
  end.sum(&:first)
end

def day02b(data)
  data.map do |id, handfuls|
    handfuls.transpose.map(&:max).reduce(&:*)
  end.sum
end

puts 'Day 02:'
puts "  Part A: #{day02a(data)}"
puts "  Part B: #{day02b(data)}"
