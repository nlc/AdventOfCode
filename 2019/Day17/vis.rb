require_relative '../intcode.rb'

intcode = Intcode.new('input.txt')

grid = intcode.execute.map{|x|x.chr}.join('').split(/\n/).map(&:chars)

# crude but effective
grid.each_with_index do |row, y|
  puts row.join('')
end
