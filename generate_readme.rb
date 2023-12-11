YEARS =
  Dir.glob('./*').select do |item|
    File.directory?(item) &&
    (item_basename = File.basename(item)) =~ /^\d{4}$/ &&
    (2015..(Time.now.year)).include?(item_basename.to_i)
  end.sort

puts "# [Advent of Code](https://adventofcode.com/)"
YEARS.reverse.each do |year|
  puts "<details#{' open' if year == YEARS.last}>"
  puts "<summary><h3><a href=#{year}>#{File.basename(year)}</a></h3></summary>"

  year_days = Dir.glob("#{year}/*").select { |item| File.basename(item) =~ /^Day\d{2}$/ }.sort

  year_days.each do |year_day|
    puzzle_path = "#{year_day}/puzzle.txt"
    day_title =
      if File.exist?(puzzle_path)
        (File.readlines(puzzle_path, chomp: true)&.first || '?').gsub(/ ?--- ?/, '')
      else
        "Day #{File.basename(year_day).gsub(/Day0?/, '')}"
      end

    # puts "<a href=#{year_day}>#{File.basename(year_day).gsub(/Day/, '')}</a>"
    puts "<a href=#{year_day}>#{day_title}</a>"
    puts '<br/>'
  end
  puts '</details>'
end
