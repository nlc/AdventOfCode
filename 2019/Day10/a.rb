require 'pp'

grid = File.readlines('input.txt').map{|line|line.chomp.chars}

asteroids = {}
grid.each_with_index do |line, y|
  line.each_with_index do |cell, x|
    if cell == '#'
      asteroids[ [x, y] ] = {}
    end
  end
end

asteroids.each do |loc, horizons|
  asteroids.keys.each do |otherloc|
    unless loc == otherloc
      # -d-> = n * -u->
      d = otherloc.zip(loc).map{|a,b|a-b}
      dabssort = d.map(&:abs).sort
      num, den = dabssort
      issorted = (dabssort != d.map(&:abs))

      n = nil
      u = nil

      if num == 0
        n = den
        u = [0, issorted ? (d[0] <=> 0) : (d[1] <=> 0)]

      else
        r = Rational(num, den)
        if issorted
          u = [r.numerator.abs * (d[1] <=> 0), r.denominator.abs * (d[0] <=> 0)]
          n = (d[1] / u[0]).abs
        else
          u = [r.numerator.abs * (d[0] <=> 0), r.denominator.abs * (d[1] <=> 0)]
          n = (d[0] / u[0]).abs
        end
      end

      if issorted
        u = u.reverse
      end

      unless horizons[u]
        horizons[u] = []
      end

      horizons[u] << n
    end
  end
end

# # Test that every vector points to another real occupied point
# asteroids.each do |loc, horizons|
#   horizons.each do |basevector, multipliers|
#     multipliers.each do |multiplier|
#       vector = basevector.map{|xy|xy*multiplier}
#       otherpt = vector.zip(loc).map{|a,b|a+b}
#       occupant = grid[otherpt[1]][otherpt[0]]
#       if occupant != '#'
#         puts loc
#       end
#     end
#   end
# end

lines_of_sight = asteroids.map do |loc, horizons|
  [loc, horizons.length]
end

pp lines_of_sight.sort{|a,b|a[1]<=>b[1]}
