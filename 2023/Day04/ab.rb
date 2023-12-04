require '../../utilities/utils.rb'

fname = ARGV.shift || 'input.txt'

cards =
  File.readlines(fname).map(&:chomp).map do |line|
    id, winners, inc = line.strip.split(/[:\|]/)
    id = id.match(/\d+/)[0].to_i
    winners = winners.strip.split(/ +/).map(&:to_i)
    inc = inc.strip.split(/ +/).map(&:to_i)

    inter = winners & inc
    numwins = inter.length

    { id:, winners:, inc:, inter:, numwins:, copies: 1 }
  end

def day04a(cards)
  cards.sum do |card|
    numwins = card[:numwins]
    numwins > 0 ? 2**(numwins-1) : 0
  end
end

# Note that this mutates the contents of "cards"!
def day04b(cards)
  cards.each do |card|
    id = card[:id]
    numwins = card[:numwins]
    if numwins > 0

      card[:copies].times do |icopy|
        next_card_ids = numwins.times.map { |x| id + x }
        next_card_ids.each do |next_card_id|
          cards[next_card_id][:copies] += 1
        end
      end
    end
  end

  cards.sum { |card| card[:copies] }
end

puts 'Day 04:'
puts "  Part A: #{day04a(cards)}"
puts "  Part B: #{day04b(cards)}"
