require 'Set'

# I'm gonna beat that crab. Eye of the tiger.

def gen_state_key(hand_a, hand_b)
  hand_a.to_s + hand_b.to_s
end

$played_games = {}

def game(hand_a, hand_b)
  state_key = gen_state_key(hand_a, hand_b) # NOTE: Do we count this initial state?

  if $played_games.key? state_key
    return $played_games[state_key]
  end

  visited = Set.new
  visited.add(state_key)

  until hand_a.empty? || hand_b.empty? do
    card_a = hand_a.shift
    card_b = hand_b.shift

    # byebug if card_a.kind_of?(Array) || card_b.kind_of?(Array)

    state_key = gen_state_key(hand_a, hand_b)

    if visited.include? state_key
      results = ['a', [hand_a, hand_b]]
      state_key = gen_state_key(hand_a, hand_b)
      $played_games[state_key] = results
      return results
    end

    visited.add(state_key)

    if (hand_a.length < card_a) || (hand_b.length < card_b)
      if card_a > card_b
        hand_a += [card_a, card_b]
      elsif card_b > card_a
        hand_b += [card_b, card_a]
      else
        raise 'Something has gone horribly wrong!'
      end
    else
      new_hand_a = hand_a[0...card_a]
      new_hand_b = hand_b[0...card_b]
      winner, state =
        # if hand_a.max > hand_b.max
        #   winner_state = ['a', [new_hand_a, new_hand_b]]
        #   state_key = gen_state_key(hand_a, hand_b)
        #   $played_games[state_key] = results
        #   winner_state
        # else
          game(new_hand_a, new_hand_b)
        # end

      case winner
      when 'a'
        hand_a += [card_a, card_b]
      when 'b'
        hand_b += [card_b, card_a]
      else
        raise 'Something has gone horribly wrong!'
      end
    end
  end

  if hand_a.empty?
    results = ['b', [hand_a, hand_b]]
    state_key = gen_state_key(hand_a, hand_b)
    $played_games[state_key] = results
    return results
  elsif hand_b.empty?
    results = ['a', [hand_a, hand_b]]
    state_key = gen_state_key(hand_a, hand_b)
    $played_games[state_key] = results
    return results
  else
    raise 'How did you get here? This shouldn\'t even be possible!'
  end
end

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

hand_a, hand_b =
  File.read(fname).split(/\n\n/).map do |str|
    str.gsub(/Player \d:\n/, '').split(/\n/).map(&:to_i)
  end

winner, state = game(hand_a, hand_b)
hand_a, hand_b = state

winning_hand = winner == 'a' ? hand_a : hand_b
winning_score =
  (1..winning_hand.length).to_a.zip(winning_hand.reverse).map do |m, n|
    m * n
  end.inject(:+)

puts "The winner is \"#{winner}\"!"
puts "The winning hand is #{winning_hand.to_s}!"
puts "The winning score is #{winning_score}!"
