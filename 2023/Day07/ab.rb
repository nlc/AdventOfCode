HAND_VALUE_SYMBOLS = %i[highcard onepair twopair three full four five]
HAND_VALUES = HAND_VALUE_SYMBOLS.zip(0...(HAND_VALUE_SYMBOLS.length)).to_h

DENOMINATION_SYMBOLS_A = %w[2 3 4 5 6 7 8 9 T J Q K A]
DENOMINATIONS_A = DENOMINATION_SYMBOLS_A.zip(0...(DENOMINATION_SYMBOLS_A.length)).to_h
DENOMINATION_SYMBOLS_B = %w[J 2 3 4 5 6 7 8 9 T Q K A]
DENOMINATIONS_B = DENOMINATION_SYMBOLS_B.zip(0...(DENOMINATION_SYMBOLS_B.length)).to_h

DENOMINATIONS = { a: DENOMINATIONS_A, b: DENOMINATIONS_B }

def handtype_a(hand)
  tallies = hand.tally
  totals = tallies.values

  return :five if totals.any?(5)
  return :four if totals.any?(4)
  if totals.any?(3)
    return :full if totals.any?(2)
    return :three
  end
  return :twopair if totals.count(2) == 2
  return :onepair if totals.count(2) == 1
  return :highcard
end

def handtype_b(hand)
  # Gotta be a more elegant way to do this but I'm too sleep-deprived
  lumps = hand.group_by { |card| card == 'J' }
  jokers = lumps[true] || []
  njokers = jokers.length
  normals = lumps[false] || []
  totals = normals.tally.values
  totals_max = totals.max || 0

  return :five if (totals_max + njokers) == 5
  return :four if (totals_max + njokers) == 4
  if (totals_max + njokers) == 3
    return :full if totals.count(2) == 2 || totals.sort == [2, 3]
    return :three
  end
  return :twopair if totals.count(2) == 2 # I think it's impossible to get 2pair with a J?
  return :onepair if (totals_max + njokers) == 2
  return :highcard
end

def handtype(hand, part)
  case part
  when :a
    handtype_a(hand)
  when :b
    handtype_b(hand)
  end
end

def compare(hand1, hand2, part)
  denominations = DENOMINATIONS[part]

  cards1, _ = hand1
  cards2, _ = hand2
  val1 = HAND_VALUES[handtype(cards1, part)]
  val2 = HAND_VALUES[handtype(cards2, part)]

  if val1 == val2
    cardval1 = cards1.map{|card|denominations[card]}
    cardval2 = cards2.map{|card|denominations[card]}

    return cardval1 <=> cardval2
  end

  return val1 <=> val2
end

def day07(hands, part)
  sorted_hands = hands.sort { |hand1, hand2| compare(hand1, hand2, part) }

  sorted_hands.zip(1..(sorted_hands.length)).sum do |(hand, bid), rank|
    bid * rank
  end
end

fname = ARGV.shift || 'input.txt'
lines = File.readlines(fname, chomp: true)

hands =
  lines.map do |line|
    hand, bid = line.split(/\s+/)
    hand = hand.chars
    bid = bid.to_i

    [hand, bid]
  end

puts 'Day 07:'
puts "  Part A: #{day07(hands, :a)}"
puts "  Part B: #{day07(hands, :b)}"
