NUMBER_PATTERN = /(\w{4}): (\d+)/.freeze
OPERATION_PATTERN = /(\w{4}): (\w{4}) ([\+\-\*\/]) (\w{4})/.freeze

File.readlines('input.txt', chomp: true).each do |line|
  case line
  when NUMBER_PATTERN
    name, number = line.match(NUMBER_PATTERN).to_a[1..]
    number = number.to_i

    puts "#{name} yells #{number}"
  when OPERATION_PATTERN
    name, input_a, operation, input_b = line.match(OPERATION_PATTERN).to_a[1..]

    puts "#{name} yells the result of #{input_a} mixed with #{input_b} via #{operation}"
  else
    raise "#{line.inspect} didn't match any known regex!"
  end
end
