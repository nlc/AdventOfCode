require 'awesome_print'

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

$part_b = fname =~ /_b\.txt$/

rule_strs, messages =
  File.read(fname).split(/\n\n/).map do |chunk|
    chunk.split(/\n/)
  end

$rules =
  rule_strs.map do |rule_str|
    index, rule_body = rule_str.split(': ')
    rule = nil

    case rule_body
    when /^"[a-z]"$/
      rule = rule_body.gsub(/"/, '')
    when /^\d+$|\d+( \d+)* (\| \d+( \d+)*)?/
      rule = rule_body.split(' | ').map do |subrule|
        subrule.split(' ').map(&:to_i)
      end
    else
      raise "Can't parse rule #{rule_body}"
    end

    [index.to_i, rule]
  end.to_h

# This likely scales horrendously but i'm curious
# I'll be darned it works like a charm
def generate_regex(rule_idx)
  if $part_b && [8, 11].include?(rule_idx)
    if rule_idx == 8
      generate_regex(42) + '+'
    elsif rule_idx == 11
      # Cheat and assume that the pattern only goes down, say, 5 levels
      max_depth = 5

      r42 = generate_regex(42)
      r31 = generate_regex(31)
      '(' + (1..max_depth).map do |depth|
        "#{r42}{#{depth}}#{r31}{#{depth}}"
      end.join('|') + ')'
    end
  else
    rule = $rules[rule_idx]

    if rule.is_a? Array
      '(' + rule.map do |subrule|
        subrule.map do |subpattern_index|
          generate_regex(subpattern_index)
        end.join
      end.join('|') + ')'
    elsif rule.is_a? String
      rule
    end
  end
end

p regex = /^#{generate_regex(0)}$/
p messages
p good_messages = messages.grep(regex)
p good_messages.length

# Part B
# "A simple example of a language that is not regular is the set of strings
#     { (a^n)(b^n) | n >= 0 }
# Intuitively, it cannot be recognized with a finite automaton, since a finite
# automaton has finite memory and it cannot remember the exact number of a's."
# https://en.wikipedia.org/wiki/Regular_language
# puts "RULE 42"
# p generate_regex(109)
# p generate_regex(119)
# puts "OR"
# p generate_regex(20)
# p generate_regex(116)
# puts
# puts "RULE 31"
# p generate_regex(95)
# p generate_regex(119)
# puts "OR"
# p generate_regex(51)
# p generate_regex(116)
