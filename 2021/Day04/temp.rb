require '../../utilities/utils.rb'

ns = File.read('nums.txt').split(/\s+/).map(&:to_i)
rbs = File.readlines('boards.txt').map{|l|l.split(/\s+/).map(&:to_i)}

bs = 100.times.map do |i|
  rbs[(i*6)...((i+1)*6 - 1)]
end

p ms = [ [ [0] * 5 ] * 5 ] * 100
ns.each do |n|
  bs.each_with_index do |b, i|
    b.each_with_index do |r, j|
      r.each_with_index do |x, k|
        ms[i][j][k] = 1
        if ms[i][j].all? {|q|q==1}
          puts "#{i} #{j} #{k}"
          exit
        end
      end
    end
  end
end
