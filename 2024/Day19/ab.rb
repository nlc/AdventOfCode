def possible?(towel, patterns)
  return true if towel.length == 0

  patterns.select do |pattern|
    towel =~ /^#{pattern}/
  end.any? do |pattern|
    possible?(towel[(pattern.length)..], patterns)
  end
end

MEMO_COUNT_WAYS = {}
def count_ways(towel, patterns)
  memo_key = [towel]
  return MEMO_COUNT_WAYS[towel] if MEMO_COUNT_WAYS.key?(towel)

  return 1 if towel.length == 0

  return MEMO_COUNT_WAYS[towel] =
    patterns.select do |pattern|
      towel =~ /^#{pattern}/
    end.sum do |pattern|
      count_ways(towel[(pattern.length)..], patterns)
    end
end

patterns_str, towels_str = File.read('input.txt').split(/\n\n/)
patterns = patterns_str.split(/, /)
towels = towels_str.split(/\n/)

# towels.each do |towel|
#   puts "#{towel.inspect}: #{possible?(towel, patterns)}"
# end

# num_possible =
#   towels.count do |towel|
#     possible?(towel, patterns)
#   end

total_ways =
  towels.sum do |towel|
    count_ways(towel, patterns)
  end

# puts num_possible
puts total_ways
