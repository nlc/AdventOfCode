# Thanks to drawing a diagram, realized pretty quickly
# that this is just modular eponentiation.
# Should have been obvious from the subject matter really.
# It's essentially Diffie-Hellman with a really small mod.

# Try a simple application of (a*b) mod m = [(a mod m) * (b mod m)] mod m
# https://en.wikipedia.org/wiki/Modular_exponentiation#Memory-efficient_method
def modexp(base, exponent, modulus)
  value = 1

  exponent.times do
    value = (value * base) % modulus
  end

  value
end

# Obviously a scalability nightmare
def modlog(base, modulus, value, max_exponent = 2**24)
  test_value = 1
  exponent = 0

  until test_value == value || exponent > max_exponent do
    test_value = (test_value * base) % modulus
    exponent += 1
  end

  if exponent <= max_exponent
    exponent
  else
    nil
  end
end

base = 7
modulus = 20201227

fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')
pub_card, pub_door = File.readlines(fname).map(&:to_i)

exp_card = modlog(base, modulus, pub_card)
exp_door = modlog(base, modulus, pub_door)

puts "log(#{pub_card}) = #{exp_card.inspect}"
puts "log(#{pub_door}) = #{exp_door.inspect}"
if exp_card.nil? || exp_door.nil?
  puts 'Better crank up the number of iterations.'
else
  # Secret = b^(e1)^(e2) mod m = b^(e1 * e2) mod m
  partial = modexp(base, exp_card, modulus)
  secret = modexp(partial, exp_door, modulus)
  puts "Secret: \033[1m#{secret}\033[0m"
end

