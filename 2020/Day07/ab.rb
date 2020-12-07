require 'Set'

def count_containing_color(target_color, rules, root_colors)
  root_colors.count do |root_color|
    child_colors = rules[root_color].map(&:last)
    child_colors.include?(target_color) ||
       count_containing_color(target_color, rules, child_colors) > 0
  end
end

def count_contained_by_color(root_color, rules)
  num = 0

  child_colors = rules[root_color].map(&:last)
  child_counts = rules[root_color].map(&:first)
  if child_counts.any?
    num += child_counts.inject(:+)
    child_colors.zip(child_counts).each do |child_color, child_count|
      num += child_count * count_contained_by_color(child_color, rules)
    end
  end

  num
end

rule_strs = File.readlines('input.txt', chomp: true)

colors = Set.new

rules =
  rule_strs.map do |rule_str|
    container_str, rest_str = rule_str.gsub(/ bags?|\.$/, '').split(' contain ')
    colors.add(container_str)

    contents_strs = rest_str =~ /no other/ ? [] : rest_str.split(', ')
    contents_strs.map! do |contents_str|
      matches = contents_str.match(/(\d+) (.*)/)
      number = matches[1].to_i
      color = matches[2]

      colors.add(color)

      [number, color]
    end

    [container_str, contents_strs]
  end.to_h

p colors

my_color = 'shiny gold'

puts "\033[1mPART 1:\033[0m #{count_containing_color(my_color, rules, colors)}"
puts "\033[1mPART 2:\033[0m #{count_contained_by_color(my_color, rules)}"
