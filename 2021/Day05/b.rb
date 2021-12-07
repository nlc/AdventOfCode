require 'pp'

d = File.readlines 'input.txt'

pairs = d.map{|l|l.split(' -> ').map{|x|x.split(',').map(&:to_i)}}

# dim = pairs.flatten.max
dim = 1000
field = Array.new(dim){Array.new(dim){0}}

pairs.each do |st, fi|
  if st[0] == fi[0]
    ast = [st[1], fi[1]].min
    afi = [st[1], fi[1]].max
    (ast..afi).each do |y|
      field[y][ st[0] ] += 1
    end
  elsif st[1] == fi[1]
    ast = [st[0], fi[0]].min
    afi = [st[0], fi[0]].max
    (ast..afi).each do |x|
      field[ st[1] ][x] += 1
    end
  else
    dvec =
      if st[0] > fi[0]
        if st[1] > fi[1] # NWward
          [-1, -1]
        else # SWward
          [-1, 1]
        end
      else
        if st[1] > fi[1] # NEward
          [1, -1]
        else # SEward
          [1, 1]
        end
      end

    vec = st
    while vec != fi
      field[ vec[1] ][ vec[0] ] += 1
      vec = vec.zip(dvec).map{|a, b|a+b}
    end
    field[ vec[1] ][ vec[0] ] += 1
  end
end

puts field.flatten.count{|x|x>1}
