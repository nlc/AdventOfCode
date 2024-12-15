MEMO = {}

def how_many_results(number, iterations)
  return 1 if iterations.zero?

  memo_key = [number, iterations]
  return MEMO[memo_key] if MEMO.key?(memo_key)

  return MEMO[memo_key] =
    if number.zero?
      how_many_results(1, iterations - 1)
    else
      digits = number.to_s.chars
      num_digits = digits.length

      if num_digits.even?
        half_num_digits = num_digits / 2
        new_number_1 = digits[0...half_num_digits].join.to_i
        new_number_2 = digits[half_num_digits..].join.to_i

        how_many_results(new_number_1, iterations - 1) + how_many_results(new_number_2, iterations - 1)
      else
        how_many_results(number * 2024, iterations - 1)
      end
    end
end

input = File.read('input.txt').chomp.split.map(&:to_i)

day11a =
  input.sum do |number|
    how_many_results(number, 25)
  end

day11b =
  input.sum do |number|
    how_many_results(number, 75)
  end

puts "Day 11:"
puts "  Part A: #{day11a}"
puts "  Part B: #{day11b}"
