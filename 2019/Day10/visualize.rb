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

asteroids.each do |loc, horizons|
  horizons.each do |basevector, multipliers|
    horizons[basevector] = multipliers.sort
  end
end

horizons = asteroids[ [11, 13] ]
targets = []
horizons.each do |basevector, multipliers|
  x, y = *basevector
  angle = (Math.atan2(y, x) + Math::PI / 2) % (Math::PI * 2)
  multipliers.each_with_index do |multiplier, index|
    effective_angle = angle + (index + 1) * Math::PI * 2
    desc = [11, 13].zip(basevector).map{|xya,xyb|xya + xyb * multiplier}
    targets << [effective_angle, desc]
  end
end

targets.sort! do |a, b|
  a[0] <=> b[0]
end

grid.each do |line|
  puts line.join('')
end
targets.each_with_index do |target, i|
  30.times do
    puts
  end
  puts i
  grid[target[1][1]][target[1][0]] = ' '
  grid.each do |line|
    puts line.join('')
  end
  sleep 0.1
end
