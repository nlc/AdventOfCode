PUZZLE_ONE_STAR  = 'The first half of this puzzle is complete! It provides one gold star: *'.freeze
PUZZLE_TWO_STARS = 'Both parts of this puzzle are complete! They provide two gold stars: **'.freeze

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
    day_title = nil
    puzzle_stars = 0

    if File.exist?(puzzle_path)
      puzzle_txt_lines = File.readlines(puzzle_path, chomp: true)

      if (day_title_matches = puzzle_txt_lines&.first.match(/^--- (Day \d+: .*) ---$/))
        day_title = day_title_matches[1]

        if puzzle_txt_lines.include?(PUZZLE_TWO_STARS)
          puzzle_stars = 2
        elsif puzzle_txt_lines.include?(PUZZLE_ONE_STAR)
          puzzle_stars = 1
        end

        day_title += '*' * puzzle_stars
      else
        raise 'Badly-formatted puzzle.txt!'
      end
    else
      day_title = "Day #{File.basename(year_day).gsub(/Day0?/, '')}"
    end

    # puts "<a href=#{year_day}>#{File.basename(year_day).gsub(/Day/, '')}</a>"
    puts "<a href=#{year_day}>#{day_title}</a>"
    puts '<br/>'
  end
  puts '</details>'
end
