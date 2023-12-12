fname = ARGV.shift || 'input.txt'

lines = File.readlines(fname, chomp: true)

data = lines.map do |line|
  record, runs = line.split(/\s+/)

  record = record * 5
  runs = ([runs] * 5).join(',')

  [record, runs.split(/,/).map(&:to_i)]
end

max_length = data.map { |record, runs| record.length }.max

def runs_regex(runs)
  /^\.*#{runs.map { |run| '#' * run }.join('\\.+')}\.*$/
end

def all_possible_springs(spring_mask)
  unknown_indices = spring_mask.chars.filter_map.with_index { |char, ichar| ichar if char == '?' }
  uil = unknown_indices.length
  spring_mask_format = spring_mask.gsub(/\?/, '%c')

  (2**uil).times.map do |n|
    sprintf(spring_mask_format, *(("%0#{uil}b" % n).chars.map{|char|%w[. #][char.to_i]}))
  end
end

def filter_springs(datum)
  spring_mask, runs = datum

  all_possible_springs(spring_mask).grep(runs_regex(runs))
end

summation =
  data.map.with_index do |datum, i|
    puts "#{i} / #{data.length}"

    filter_springs(datum).length
  end.sum

p summation
