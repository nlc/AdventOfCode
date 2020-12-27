# require 'awesome_print'
require 'set'

$visited_sizes = {}

$game = 0
def play_subgame(hand_a, hand_b)
  $game += 1
  # puts "game #{$game}"

  # visited = Set.new
  visited = Hash.new

  num_rounds = 0
  repeat = false
  until hand_a.empty? || hand_b.empty? || repeat
    # visited_key = [hand_a, hand_b]
    # return 'a' if visited.include?(visited_key)
    # visited.add(visited_key)
    visited_key = [hand_a, hand_b]
    return 'a' if visited.key?(visited_key) && visited[visited_key] == visited_key
    visited[visited_key] = visited_key

    play_round(hand_a, hand_b)
    num_rounds += 1
  end

  $visited_sizes[visited.hash] = visited.size

  hand_b.empty? ? 'a' : 'b'
end

def play_round(hand_a, hand_b)
  card_a = hand_a.shift
  card_b = hand_b.shift
  winner = nil

  winner =
    if (card_a <= hand_a.length && card_b <= hand_b.length)
      # puts " recursing"
      w = play_subgame(hand_a.first(card_a), hand_b.first(card_b))
      # puts " back"
      w
    else
      if card_a > card_b
        'a'
      elsif card_b > card_a
        'b'
      else
        raise 'Equal cards!(?)'
      end
    end

  case winner
  when 'a'
    hand_a << card_a
    hand_a << card_b
  when 'b'
    hand_b << card_b
    hand_b << card_a
  else
    raise 'Winner still nil!'
  end

  # puts " #{winner}"
  return winner
end

def score(hand)
  s = hand.length

  sc = 0
  hand.map.with_index do |e, i|
    e * (s - i)
  end.inject(:+)
end

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

hand_a, hand_b =
  File.read(fname).split(/\n\n/).map do |str|
    str.gsub(/Player \d:\n/, '').split(/\n/).map(&:to_i)
  end

winner = play_subgame(hand_a, hand_b)
winning_hand = hand_b.empty? ? hand_a : hand_b
winning_score = score(winning_hand)

puts "Player #{winner} wins with a score of #{winning_score}."

p $visited_sizes.values.inject(:+)
