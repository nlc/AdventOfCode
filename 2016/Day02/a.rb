require '../../utilities/utils.rb'

# +-------+
# | 1 2 3 |
# | 4[5]6 |
# | 7 8 9 |
# +-------+

class Dialer
  attr_accessor :x, :y

  def initialize(button)
    x, y = button_to_xy(button)
    @x = x.clamp(0..2)
    @y = y.clamp(0..2)
  end

  def button
    xy_to_button(@x, @y)
  end

  def move!(directions)
    directions.gsub(/[^RULD]/, '').chars.each do |direction|
      case direction
      when 'R'
        @x += 1
      when 'U'
        @y -= 1
      when 'L'
        @x -= 1
      when 'D'
        @y += 1
      else
        raise "Direction #{direction.inspect} invalid!"
      end

      clamp!
    end

    button
  end

  private

  def button_to_xy(button)
    raise "Button #{button} out of range!" unless (1..9).include? button

    b = button - 1
    [b % 3, b / 3]
  end

  def xy_to_button(x, y)
    raise "Coords #{[@x, @y].inspect} out of range!" unless ((0..2).include? @x) && ((0..2).include? @y)

    1 + x + y * 3
  end

  def clamp!
    @x = @x.clamp(0..2)
    @y = @y.clamp(0..2)
  end
end

dialer = Dialer.new(5)
input = readlines("input.txt")

combination =
  input.map do |line|
    dialer.move!(line)
  end

puts combination.join
