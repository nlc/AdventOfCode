require 'set'

def apply_rules(a, b, followers_of)
  if followers_of[a]&.include?(b)
    -1
  elsif followers_of[b]&.include?(a)
    1
  else
    0
  end
end

def middle(arr)
  arr[(arr.length / 2).floor]
end

rules, sequences =
  File.read('input.txt').split(/\n\n/).map do |e|
    e.split(/\n/).map do |ee|
      ee.split(/\||,/).map(&:to_i)
    end
  end

followers_of = {}
rules.each do |leader, follower|
  followers_of[leader] = Set.new unless followers_of.key?(leader)
  followers_of[leader].add(follower)
end

good_sum = 0
bad_sum = 0
sequences.each do |seq|
  sorted =
    seq.sort do |a, b|
      apply_rules(a, b, followers_of)
    end

  if seq == sorted
    good_sum += middle(seq)
  else
    bad_sum += middle(sorted)
  end
end

puts "Day 05:"
puts "  Part A: #{good_sum}"
puts "  Part B: #{bad_sum}"
