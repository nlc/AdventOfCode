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
  noinput: 'lacks input.txt',
  noscript: 'lacks properly-named script'
}

def parse_contents(path, contents)
  complaints = []

  if contents.empty?
    complaints << :empty
  else
    if contents.include?('puzzle.txt')
      puzzle_txt_lines = File.readlines("#{path}/puzzle.txt", chomp: true)
      if puzzle_txt_lines.first !~ /^--- Day \d+: .* ---$/
        complaints << :puzztitle
      end
    else
      complaints << :nopuzzle
    end

    if !contents.include?('input.txt')
      complaints << :noinput
    end

    if !contents.grep(/^ab?\./).any?
      complaints << :noscript
    end

    # TODO: Somehow check for proper formatting of output of ab.whatever?
    # TODO: Parse for
    #   The first half of this puzzle is complete! It provides one gold star: *
    #   and
    #   Both parts of this puzzle are complete! They provide two gold stars: **
  end

  complaints
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

      complaints =
        if Dir.exist?(folder_path)
          contents = Dir.glob("#{folder_path}/*").map { |full_path| File.basename(full_path) }

          parse_contents(folder_path, contents)
        else
          options[:report_missing] ? [:missing] : []
        end

      [day, complaints]
    end.to_h

  unless year_days.compact.all? { |day, complaints| complaints.empty? }
    puts "#{year}:"
    year_days.compact.each do |day, complaints|
      case complaints.length
      when 0
      when 1
        printf("  Day %2d: %s\n", day, COMPLAINT_MESSAGES[complaints.first])
      else
        printf("  Day %2d:\n", day)
        complaints.each do |complaint|
          puts "    #{COMPLAINT_MESSAGES[complaint]}"
        end
      end
    end
  end
end
