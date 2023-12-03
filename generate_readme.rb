YEARS =
  Dir.glob('./*').select do |item|
    File.directory?(item) &&
    (item_basename = File.basename(item)) =~ /^\d{4}$/ &&
    (2015..(Time.now.year)).include?(item_basename.to_i)
  end.sort

puts "# [Advent of Code](https://adventofcode.com/)"
# puts "### By Year:"
YEARS.each do |year|
  puts "### [#{File.basename(year)}](#{year})"

  year_days = Dir.glob("#{year}/*").select { |item| File.basename(item) =~ /Day\d{2}/ }.sort

  year_days.each do |year_day|
    print "[#{File.basename(year_day).gsub(/Day/, '')}](#{year_day}) "
  end
  puts
end
