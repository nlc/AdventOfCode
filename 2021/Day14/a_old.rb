input = File.readlines('sample.txt', chomp: true)

template = input.first.chars
rules = input[2..].map { |line| line.split(' -> ') }.to_h

posschars = (template + rules.keys.map(&:chars).flatten + rules.values.flatten).uniq.sort
print "    "
posschars.each do |tx|
  print "#{tx} "
end
puts
puts "  +" + "-" * (posschars.length * 2)
posschars.each do |ty|
  print "#{ty} | "
  posschars.each do |tx|
    res = rules[ty + tx]
    if res.nil?
      print "  "
    else
      print "#{res} "
    end
  end
  puts
end

def iterate(template, rules)
  template.each_cons(2).map do |a|
    [a[0], rules[a.join]]
  end.flatten + [template.last]
end

def iterate_old(template, rules)
  template.each_cons(2).map do |a|
    [a[0], rules[a.join], a[1]].compact[..1]
  end.flatten.join + [template.last]
end

string = template
# tallies =
#   10.times.map do |i|
#     string = iterate(string, rules)
#     p string.length
#     string.tally
#   end
# 
# p string.join

def diffs(arr)
  arr[..-2].zip(arr[1..]).map { |a, b| b - a }
end
# bs = tallies.map { |x| x['B'] }
# p diffs(bs)
# p diffs(diffs(bs))
# p diffs(diffs(diffs(bs)))
# p diffs(diffs(diffs(diffs(bs))))

tallies = string.tally
p tallies.values.max - tallies.values.min

def add_tallies(t1, t2)
  (t1.keys | t2.keys).map do |k|
    v1 = t1[k] || 0
    v2 = t2[k] || 0

    [k, v1 + v2]
  end.to_h
end

def subtract_tallies(t1, t2)
  (t1.keys | t2.keys).map do |k|
    v1 = t1[k] || 0
    v2 = t2[k] || 0

    [k, v1 - v2]
  end.to_h
end

@memo = {}
def count_elements_between_at_depth(left, right, depth, rules)
  puts "Invoked count_elements_between_at_depth(#{left}, #{right}, #{depth}, <rules>)"

  memokey = [left, right, depth]
  return @memo[memokey] if @memo.key?(memokey)

  lr_tally = add_tallies({ left => 1 }, { right => 1 })

  center = rules[left + right]
  lcr_tally = add_tallies(lr_tally, { center => 1 })
  lccr_tally = add_tallies(lr_tally, { center => 2 })

  return lcr_tally if depth < 2

  leftside_tally = count_elements_between_at_depth(left, center, depth - 1, rules)
  rightside_tally = count_elements_between_at_depth(center, right, depth - 1, rules)

  sub_tally = add_tallies(leftside_tally, rightside_tally)

  # @memo[memokey] = subtract_tallies(sub_tally, lcr_tally)
  @memo[memokey] = subtract_tallies(sub_tally, lr_tally)
end

N = 2

ans = count_elements_between_at_depth('N', 'N', N + 1, rules)
puts "ans = #{ans.inspect}"
p @memo

string = 'NN'.chars
N.times.map do |i|
  string = iterate(string, rules)
end

puts "real answer: #{string.tally.inspect}"

exit
