require 'Set'

# rule_strs = File.readlines('input.txt', chomp: true)
rule_strs = File.readlines('temp.txt', chomp: true)[7...16]

colors = Set.new

rules =
  rule_strs.map do |rule_str|
    # light red bags contain 1 bright white bag, 2 muted yellow bags.
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

p rules
p colors
