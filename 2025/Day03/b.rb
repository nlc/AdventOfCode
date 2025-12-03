sample = File.readlines('sample.txt', chomp: true).map { |line| line.chars.map(&:to_i) }
input = File.readlines('input.txt', chomp: true).map { |line| line.chars.map(&:to_i) }

def recursive_solution(k, num_array)
  d = num_array.length
  return [num_array.max] if k == 1

  n = num_array.first(d - k + 1).max
  cdr = recursive_solution(k - 1, num_array.drop(num_array.index(n) + 1))

  [n] + cdr
end

k=12
p input.map { |e| recursive_solution(k, e).join.to_i }.sum
