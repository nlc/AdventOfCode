File.readlines('sample.txt',chomp:true).map{|line|line.split(',').map(&:to_i)}
