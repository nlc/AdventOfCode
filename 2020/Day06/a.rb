cts =
File.read(ARGV.shift).split(/\n{2,}/).map do |grp|
  grp.gsub(/\s+/, '').chars.uniq.length
end

puts cts.inject(:+)
