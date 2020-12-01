require_relative '../intcode.rb'

maxval = 0

(0...5).to_a.permutation.each do |perm|
  intcodes = []
  5.times do
    intcodes << Intcode.new('input.txt')
  end

  5.times do |pi|
    intcodes[pi].execute(perm[pi])
  end

  value = 0
  intcodes.each do |intcode|
    value = intcode.execute(value)[0]
  end

  if value > maxval
    maxval = value
  end
end

puts maxval
