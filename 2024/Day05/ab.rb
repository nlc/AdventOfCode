require 'set'

rule_pairs, seq_arrs = File.read('input.txt').split(/\n\n/).map{|e|e.split(/\n/).map{|ee|ee.split(/\||,/).map(&:to_i)}}

followers_of = {}
leaders_of = {}
rule_pairs.each do |leader, follower|
  followers_of[leader] = Set.new unless followers_of.key?(leader)
  followers_of[leader].add(follower)

  leaders_of[follower] = Set.new unless leaders_of.key?(follower)
  leaders_of[follower].add(leader)
end

def apply_rules(a, b, followers_of, leaders_of)
  if followers_of[a]&.include?(b)
    -1
  elsif leaders_of[a]&.include?(b)
    1
  else
    0
  end
end

def middle(arr)
  arr[(arr.length / 2).floor]
end

good_sum = 0
bad_sum = 0

seq_arrs.each do |seq|
  sorted =
    seq.sort do |a, b|
      apply_rules(a, b, followers_of, leaders_of)
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
