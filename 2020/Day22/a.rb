require 'awesome_print'

def play_round(hand_a, hand_b)
  card_a = hand_a.deq
  card_b = hand_b.deq

  if card_a > card_b
    hand_a.enq card_a
    hand_a.enq card_b
  elsif card_b > card_a
    hand_b.enq card_b
    hand_b.enq card_a
  else
    raise 'Equal cards!(?)'
  end
end

def score(hand)
  s = hand.size

  sc = 0
  hand.size.times do |i|
    sc += hand.deq * (s - i)
  end

  sc
end

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

hand_arr_a, hand_arr_b =
  File.read(fname).split(/\n\n/).map do |str|
    str.gsub(/Player \d:\n/, '').split(/\n/).map(&:to_i)
  end

hand_a = Queue.new
hand_b = Queue.new
hand_arr_a.each { |e| hand_a.enq(e) }
hand_arr_b.each { |e| hand_b.enq(e) }

num_rounds = 0
until hand_a.empty? || hand_b.empty?
  play_round(hand_a, hand_b)
  num_rounds += 1
end

winner = hand_b.empty? ? 'a' : 'b'
winning_hand = hand_b.empty? ? hand_a : hand_b
winning_score = score(winning_hand)

puts "Player #{winner} wins with a score of #{winning_score} after #{num_rounds} rounds."
