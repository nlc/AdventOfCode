require '../../utilities/utils.rb'

def pp_board(b, m)
  5.times do |i|
    5.times do |j|
      print "%s% 3d\033[0m" % [(m[i][j] ? "\033[1m" : ''), b[i][j]]
    end
    puts
  end
end

# no break statements for me apparently
def part_a(raw)
  ns = raw.shift.split(/,/).map(&:to_i)
  raw.shift
  bs = raw.grep(/\d/).each_slice(5).map{|l|l.map{|x|x.strip.split(/ +/).map(&:to_i)}}

  ms = Array.new(bs.length){Array.new(5){Array.new(5){false}}}

  ns.each_with_index do |n, t|
    bs.each_with_index do |b, i|
      b.each_with_index do |r, j|
        r.each_with_index do |x, k|
          ms[i][j][k] = true if bs[i][j][k] == n
          if ms[i][j].all? || ms[i].all?{|r|r[j]}
            sum = b.flatten.zip(ms[i].flatten).select{|bb, mm|!mm}.map{|bb, mm|bb}.inject(:+)
            # pp_board(b, ms[i])

            return n * sum
          end
        end
      end
    end
  end

  return 'NO RESULT'
end

def part_b(raw)
  ns = raw.shift.split(/,/).map(&:to_i)
  raw.shift
  bs = raw.grep(/\d/).each_slice(5).map{|l|l.map{|x|x.strip.split(/ +/).map(&:to_i)}}
  finished_board_indices = []
  finish_nums = []
  sum = 0
  res = 0

  ms = Array.new(bs.length){Array.new(5){Array.new(5){false}}}

  ns.each_with_index do |n, t|
    bs.each_with_index do |b, i|
      b.each_with_index do |r, j|
        r.each_with_index do |x, k|
          ms[i][j][k] = true if bs[i][j][k] == n
          if (ms[i][j].all? || ms[i].all?{|r|r[j]}) && (!finished_board_indices.include? i)
            finished_board_indices << i

            sum = bs[i].flatten.zip(ms[i].flatten).select{|bb, mm|!mm}.map{|bb, mm|bb}.inject(:+)
            res = n * sum
          end
        end
      end
    end
  end

  return res
end

fname = 'input.txt'
puts 'Day 04:'
puts "  Part A: #{part_a(File.readlines(fname))}"
puts "  Part B: #{part_b(File.readlines(fname))}"
