require 'optparse'

STARTING_YEAR = 2015
CURRENT_YEAR = Time.now.year
STARTING_DAY = 1
ENDING_DAY = 25

COMPLAINT_MESSAGES = {
  missing: 'folder is missing',
  empty: 'folder is empty',
  nopuzzle: 'lacks puzzle.txt',
  puzztitle: 'puzzle.txt lacks properly-formatted title',
  puzzlong: 'has long lines in puzzle.txt',
  noinput: 'lacks input.txt',
  noscript: 'lacks properly-named script',
  onlyascript: 'has two stars but only a-named script'
}

PUZZLE_ONE_STAR  = 'The first half of this puzzle is complete! It provides one gold star: *'.freeze
PUZZLE_TWO_STARS = 'Both parts of this puzzle are complete! They provide two gold stars: **'.freeze

def parse_contents(path, contents)
  complaints = []
  stars_from_puzzle_txt = nil

  if contents.empty?
    complaints << :empty
  else
    if contents.include?('puzzle.txt')
      puzzle_txt_lines = File.readlines("#{path}/puzzle.txt", chomp: true)

      if puzzle_txt_lines.any? { |line| line.length > 80 }
        complaints << :puzzlong
      end

      if puzzle_txt_lines.first !~ /^--- Day \d+: .* ---$/
        complaints << :puzztitle
      else
        if puzzle_txt_lines.include?(PUZZLE_ONE_STAR)
          stars_from_puzzle_txt = 1
        elsif puzzle_txt_lines.include?(PUZZLE_TWO_STARS)
          stars_from_puzzle_txt = 2
        else
          stars_from_puzzle_txt = 0
        end
      end
    else
      complaints << :nopuzzle
    end

    if !contents.include?('input.txt')
      complaints << :noinput
    end

    if !contents.grep(/^ab?\./).any?
      complaints << :noscript
    elsif stars_from_puzzle_txt == 2 && !contents.grep(/^a?b\./).any?
      complaints << :onlyascript
    end

    # TODO: Somehow check for proper formatting of output of ab.whatever?
  end

  [complaints, stars_from_puzzle_txt]
end

options = {}
opt_parser =
  OptionParser.new do |opts|
    opts.on('-m', '--report-missing', 'Also report when a folder is missing') { |m| options[:report_missing] = true }
  end
opt_parser.parse!

(STARTING_YEAR..CURRENT_YEAR).each do |year|
  year_days =
    (STARTING_DAY..ENDING_DAY).map do |day|
      folder_path = "./#{year}/Day#{day}"
      folder_path = sprintf('./%d/Day%02d', year, day)

      complaints = options[:report_missing] ? [:missing] : []
      stars_from_puzzle_txt = nil
      if Dir.exist?(folder_path)
        contents = Dir.glob("#{folder_path}/*").map { |full_path| File.basename(full_path) }

        complaints, stars_from_puzzle_txt = parse_contents(folder_path, contents)
      end

      [day, complaints, stars_from_puzzle_txt]
    end

  unless year_days.compact.all? { |day, complaints, stars_from_puzzle_txt| complaints.empty? }
    puts "#{year}:"
    year_days.compact.each do |day, complaints, stars_from_puzzle_txt|
      case complaints.length
      when 0
      when 1
        printf("  Day %2d (% 2d stars): %s\n", day, stars_from_puzzle_txt || 0, COMPLAINT_MESSAGES[complaints.first])
      else
        printf("  Day %2d (% 2d stars):\n", day, stars_from_puzzle_txt || 0)
        complaints.each do |complaint|
          puts "    #{COMPLAINT_MESSAGES[complaint]}"
        end
      end
    end
  end
end
