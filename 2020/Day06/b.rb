cts =
File.read(ARGV.shift).split(/\n{2,}/).map do |grp|
  grp.split(/\n/).map(&:chars).inject(:&).length
end

puts cts.inject(:+)
