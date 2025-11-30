sample = '2333133121414131402'
sample = '12345'

input = sample
input = File.read('input.txt').chomp

fs, gs = input.chars.map(&:to_i).append(0).each_slice(2).to_a.transpose

p fs_total = fs.sum
fs_tally = fs.first
gs_tally = 0
# flipover point is when the number of gaps
# already seen (gs_tally) is large enough
# to accommodate (is equal to) the number of
# remaining fileblocks (fs_total - fn_tally)
chunk_idx = 1
fs[1..].zip(gs[..-2]).each do |fn, gn|
  fs_tally += fn
  gs_tally += gn

  puts "chunk #{chunk_idx}: is gs_tally=#{gs_tally} >= remaining=#{fs_total - fs_tally} ? #{gs_tally >= fs_total - fs_tally}"

  chunk_idx += 1
end
