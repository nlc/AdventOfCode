# This could deeeeefffffinitely use some optimization, takes maybe 4-5 minutes
# to do Part B
# Although it turns out that printing every iteration was slowing it down
# by a massive amount. Currently runs in 55 seconds, not great but better.

def nth_term(starting_numbers, iterations)
  last_spoken = {}
  number = 0
  iterations.times do |i|
    to_say = nil
    if i < starting_numbers.length
      to_say = starting_numbers[i]
    elsif last_spoken.key?(number) && last_spoken[number].length == 1
      to_say = 0
    elsif last_spoken.key?(number) && last_spoken[number].length > 1
      to_say = last_spoken[number].last(2).reverse.inject(:-)
    else
      raise 'not a starter or last spoken with at least 1 instance!'
    end

    if last_spoken.key?(to_say)
      last_spoken[to_say] = [last_spoken[to_say].last, i + 1]
    else
      last_spoken[to_say] = [i + 1]
    end
    # puts to_say
    number = to_say

    if i % 1000 == 0
      printf("\r\033[2K%d / %d (%0.2f %%)", i, iterations, 100 * i.to_f / iterations)
    end
  end

  number
end

starting_numbers = File.readlines(ARGV.shift, chomp: true).first.split(',').map(&:to_i)

puts "\033[1mPART A:\033[0m"
solution = nth_term(starting_numbers, 2020)
puts "\r\033[2K\033[A\033[8C#{solution}"

puts "\033[1mPART B:\033[0m"
solution = nth_term(starting_numbers, 30000000)
puts "\r\033[2K\033[A\033[8C#{solution}"
