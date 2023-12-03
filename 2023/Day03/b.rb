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
  [ 1, -1]
]

def coord_nbrs(coord)
  NBRHD.map do |nbr|
    coord.zip(nbr).map{|a, b|a+b}
  end
end

fname = ARGV.shift || 'input.txt'

input = readlines(fname).map(&:chars)

possible_gears = {}
digits = {}

input.each_with_index do |row, y|
  row.each_with_index do |char, x|
    coord = [x, y]

    case char
    when /\./
      # do nothing
    when /\d/ # digit
      digits[coord] = char
    when /\*/ # possible gear
      possible_gears[coord] = char
    end
  end
end

number_to_poss_gears = {}
coord_number_to_poss_gears = {}
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

  adj_poss_gears = halo.select { |halo_coord| possible_gears.key?(halo_coord) }.uniq

  starting_coord = [minx + 1, y]
  number_to_poss_gears[num_str] = adj_poss_gears
  coord_number_to_poss_gears[[coord, num_str]] = adj_poss_gears
end

# p coord_number_to_poss_gears

poss_gear_to_numbers = {}
poss_gear_to_coord_numbers = {}
coord_number_to_poss_gears.each do |coord_number, poss_gears|
  coord, number = coord_number
  poss_gears.each do |poss_gear|
    poss_gear_to_numbers[poss_gear] = [] unless poss_gear_to_numbers.key?(poss_gear)

    poss_gear_to_numbers[poss_gear] << number
  end
end

gears =
  poss_gear_to_numbers.select do |poss_gear, numbers|
    numbers.length == 2
  end.to_h

p gears.map{|gear, numbers|numbers.map(&:to_i).reduce(&:*)}.sum
