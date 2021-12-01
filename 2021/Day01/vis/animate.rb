def load_sprite(fname)
  File.readlines(fname).map do |line|
    line.gsub(/'/, "\0").chars
  end
end

def draw_sprite(sprite, y_start=1, x_start=1, color="\033[0m")
  print color

  sprite.each_with_index do |line, j|
    y = y_start + j
    line.each_with_index do |char, i|
      x = x_start + i
      if char != "\0"
        print "\033[#{y};#{x}H"
        print char
      end
    end
  end
end

def draw_waves()
  print "\033[34m"

  y = 6
  80.times do |i|
    x = i + 1
    print "\033[#{y};#{x}H"
    print '~'
  end

  print "\033[0m"
end

def draw_seafloor(offset)
  print "\033[33m"

  depths = File.readlines('../input.txt').first(160).map(&:to_i)
  max_depth = depths.max
  min_depth = depths.min
  depth_range = max_depth - min_depth
  actual_range = 16

  y_start = 25
  80.times do |i|
    x = i + 1
    depth = depths[offset + i]
    pseudodepth = ((depth - min_depth) / depth_range.to_f * actual_range.to_f).to_i
    y = y_start + pseudodepth

    print "\033[#{y};#{x}H"
    print %w[- = #].sample
  end

  print "\033[0m"
end

def draw_bubbles(n)
  n.times do
    x = rand(80)
    y = rand(8..20)

    print "\033[#{y};#{x}H"
    print %w[. o O ()].sample
  end
end

sub = load_sprite('sub.asc')

t = 0
print "\033[?25l"
80.times do
  print "\033[2J\033[H"
  draw_sprite(sub, 3 + (2 * Math.sin(t / 2.0)).to_i, 10, "\033[31m")
  draw_waves
  draw_seafloor(t)
  draw_bubbles(rand(5..12))

  t += 1
  sleep 0.5
end
print "\033[?25h"
