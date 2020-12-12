# Shame I gotta do this language change but I'm behind a day

$nbr_vectors = [
  [-1, -1], [-1, 0], [-1, 1],
  [0, -1],  [0, 0],  [0, 1],
  [1, -1],  [1, 0],  [1, 1]
]

def init_neighbors_a(mask_bits) # Trivial for part A
  neighbors = {}
  mask_bits.length.times do |y|
    mask_bits[y].length.times do |x|
      neighbors[[y, x]] = []
      if mask_bits[y][x] == 1
        $nbr_vectors.each do |dy, dx|
          new_y = y + dy
          new_x = x + dx
          if (0...mask_bits.length).include?(new_y) && (0...mask_bits[y].length).include?(new_x)
            neighbors[[y, x]] << [new_y, new_x]
          end
        end
      end
    end
  end

  neighbors
end

def init_neighbors_b(mask_bits) # Crucial for part B
  neighbors = {}
  mask_bits.length.times do |y|
    mask_bits[y].length.times do |x|
      neighbors[[y, x]] = []
      if mask_bits[y][x] == 1
        $nbr_vectors.each do |dy, dx|
          new_y = y + dy
          new_x = x + dx

          while (0...mask_bits.length).include?(new_y) && (0...mask_bits[y].length).include?(new_x)
            if mask_bits[new_y][new_x] == 1
              neighbors[[y, x]] << [new_y, new_x]
              break
            end

            new_y += dy
            new_x += dx
          end
        end
      end
    end
  end

  neighbors
end

def rule_a(center, sum)
  ((center == 1 && sum < 5) || (center == 0 && sum == 0)) ? 1 : 0
end

def rule_b(center, sum)
  ((center == 1 && sum < 6) || (center == 0 && sum == 0)) ? 1 : 0
end

def apply(new_state_bits, state_bits, mask_bits, neighbors, rule_method)
  changed_bits = 0
  state_bits.length.times do |y|
    state_bits[y].length.times do |x|
    center_bit = state_bits[y][x]
      sum =
        neighbors[[y, x]].map do |test_y, test_x|
          state_bits[test_y][test_x]
        end.inject(:+)
      new_state_bits[y][x] = send(rule_method, center_bit, sum)
      if center_bit != new_state_bits[y][x]
        changed_bits += 1
      end
    end
  end

  changed_bits
end

def perform(mask_bits, init_neighbors_method, rule_method)
  neighbors = send(init_neighbors_method, mask_bits)
  height = mask_bits.length
  width = mask_bits[0].length

  all_state_bits = Array.new(2) { Array.new(height) { Array.new(width) { 0 } } }
  state_index = 0

  changed = 0
  while((changed = apply(all_state_bits[state_index], all_state_bits[(state_index + 1) % 2], mask_bits, neighbors, rule_method)) > 0)
    state_index = (state_index + 1) % 2
  end

  all_state_bits[0].map do |line|
    line.inject(:+)
  end.inject(:+)
end

fname = 'input.txt'

mask_bits =
  File.readlines(fname, chomp: true).map do |line|
    line.chars.map do |char|
      {'.' => 0, 'L' => 1}[char]
    end
  end

puts "\033[1mPART A:\033[0m"
puts "\033[1mPART B:\033[0m"

print "\r\033[2A\033[8C#{perform(mask_bits, :init_neighbors_a, :rule_a)}"
print "\r\033[B\033[8C#{perform(mask_bits, :init_neighbors_b, :rule_b)}"

puts
