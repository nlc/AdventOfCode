require_relative '../intcode.rb'

maxval = 0

(5...10).to_a.permutation.each do |perm|
  intcodes = []
  5.times do
    intcodes << Intcode.new('input.txt')
  end

  5.times do |pi|
    intcodes[pi].execute(perm[pi])
  end

  cont = true
  value = 0
  while cont do
    intcodes.each do |intcode|
      if intcode.running?
        value = intcode.execute(value)[0]
      else
        cont = false
        break
      end
    end
  end

  if value > maxval
    maxval = value
  end
end

puts maxval
