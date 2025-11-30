# Exploring the logic--final answer must be in J

MEMO_INTPARTITIONS = {}
def intpartitions(n, k)
  return MEMO_INTPARTITIONS[[n, k]] if MEMO_INTPARTITIONS.key?([n, k])

  return [[n]] if k == 1
  return [] if k > n
  return [[1] * k] if k == n

  MEMO_INTPARTITIONS[[n, k]] =
    (0..(n-k+1)).map do |m|
      intpartitions(n - m, k - 1).map do |p|
        [m] + p
      end
    end.flatten(1)
end

def score(vectors, amounts)
  (0...4).map do |property_idx|
    property_sum =
      vectors.map.with_index do |vector, vector_idx|
        vector[property_idx] * amounts[vector_idx]
      end.sum

    property_sum = 0 if property_sum < 0

    property_sum
  end.inject(&:*)
end

# p score([ [ -1, -2, 6, 3, 8 ], [ 2, 3, -2, -1, 3 ] ], [44, 56])

ingredients = File.readlines('input.txt').map do |line|
  line.scan(/(-?(\d+))/).map do |match|
    match.first.to_i
  end
end

# p ingredients

best_combo =
  intpartitions(100, 4).max_by do |partition|
    score(ingredients, partition)
  end

p best_combo
p score(ingredients, best_combo)
