sample = '2333133121414131402'

input = sample
# input = File.read('input.txt').chomp

fns, gns = ((allns = input.chars.map(&:to_i)) + [0]).each_slice(2).to_a.transpose

left_idx = 0 # index into fns
right_idx = fns.length - 1
left_ticker = nil # count down to "expand" "file"
right_ticker = nil # count down to "expand" "file"

final_sum = 0
is_left = true

position = 0

curr_right = 0
# until left_idx >= right_idx
until position >= fns.sum
  if is_left
    fns[left_idx].times do |tick| # todo do this with math
      print fns[left_idx]
      final_sum += position * fns[left_idx]
      position += 1
    end
    left_idx += 1
    is_left = false
  else
    if curr_right == 0
      curr_right = fns[right_idx]
    end

    gns[left_idx].times do |tick|
      print curr_right
      final_sum += position * curr_right
      position += 1
    end

    fns[right_idx] -= gns[left_idx]
    if fns[right_idx] == 0
      right_idx -= 1
    end

    is_left = true
  end
end

p final_sum
