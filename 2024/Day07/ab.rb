MEMO_ODOMETER = {}
def odometer(base, places)
  k = [base, places]
  return MEMO_ODOMETER[k] if MEMO_ODOMETER.key?(k)

  MEMO_ODOMETER[k] =
    (base ** places).times.map do |i|
      (([0] * places) + (i.to_s(base).chars.map(&:to_i))).last(places)
    end
end

MEMO_ODOMETRIZE = {}
def odometrize(array, places)
  k = [array, places]
  return MEMO_ODOMETRIZE[k] if MEMO_ODOMETRIZE.key?(k)

  MEMO_ODOMETRIZE[k] =
    odometer(array.length, places).map do |index_array|
      index_array.map do |index|
        array[index]
      end
    end
end

def evaluate(calibrators, operators)
  first_calibrator = calibrators.first
  calibrators.drop(1).zip(operators).reduce(first_calibrator) do |resultant, calibrator_operator|
    calibrator, operator = calibrator_operator

    case operator
    when '*'
      resultant * calibrator
    when '+'
      resultant + calibrator
    when '.'
      (resultant.to_s + calibrator.to_s).to_i
    end
  end
end

def apply(input, operator_set)
  input.sum do |testval, calibrators|
    odometrize(operator_set, calibrators.length - 1).any? do |operators|
      evaluate(calibrators, operators) == testval
    end ? testval : 0
  end
end

def day07a(input)
  apply(input, %w[+ *])
end

def day07b(input)
  apply(input, %w[+ * .])
end

input =
  File.readlines('input.txt', chomp: true).map do |line|
    testval_str, calibrators_str = line.split(/: /)

    testval = testval_str.to_i
    calibrators = calibrators_str.split.map(&:to_i)

    [testval, calibrators]
  end

puts "Day 07:"
puts "  Part A: #{day07a(input)}"
puts "  Part B: #{day07b(input)}"
