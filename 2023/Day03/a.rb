require '../../utilities/utils.rb'
require 'byebug'

NBRHD = [
  [ 1,  0],
  [ 1,  1],
  [ 0,  1],
  [-1,  1],
  [-1,  0],
  [-1, -1],
  [ 0, -1],
  [1, -1]
]

def coord_nbrs(coord)
  NBRHD.map do |nbr|
    coord.zip(nbr).map{|a, b|a+b}
  end
end

fname = ARGV.shift || 'input.txt'

input = readlines(fname).map(&:chars)

symbols = {}
digits = {}

input.each_with_index do |row, y|
  row.each_with_index do |char, x|
    coord = [x, y]

    case char
    when /\./
      # do nothing
    when /\d/ # digit
      digits[coord] = char
    else # symbol
      symbols[coord] = char
    end
  end
end

mysum = 0

numbers = {}
digits.each do |coord, digit|
  x, y = coord
  minx = x
  maxx = x + 1

  included_coords = []
  num_str = ''

  while digits.key?([minx, y])
    included_coords << [minx, y]
    num_str = digits.delete([minx, y]) + num_str
    minx -= 1
  end

  while digits.key?([maxx, y])
    included_coords << [maxx, y]
    num_str = num_str + digits.delete([maxx, y])
    maxx += 1
  end

  halo = included_coords.map { |included_coord| coord_nbrs(included_coord) }.flatten(1)

  if halo.any? { |halo_coord| symbols.key?(halo_coord) }
    # puts "#{num_str} is a match! #{halo.inspect}" end
    mysum += num_str.to_i
  end


  starting_coord = [minx + 1, y]
  numbers[coord] = num_str
end

p mysum
