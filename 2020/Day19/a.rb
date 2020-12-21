require 'awesome_print'

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

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
  rule = $rules[rule_idx]

  if rule.is_a? Array
    '(' + rule.map do |subrule|
      subrule.map do |subpattern_index|
        if subpattern_index == rule_idx
        end
        generate_regex(subpattern_index)
      end.join
    end.join('|') + ')'
  elsif rule.is_a? String
    rule
  end
end

# p regex = /^#{generate_regex(0)}$/
# p messages
# p good_messages = messages.grep(regex)
# p good_messages.length

p generate_regex(11)
