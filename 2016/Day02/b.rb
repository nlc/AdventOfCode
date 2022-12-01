require '../../utilities/utils.rb'

# +-----------+
# |     1     |
# |   2 3 4   |
# | 5 6 7 8 9 |
# |   A B C   |
# |     D     |
# +-----------+

KEYBOARD = [
  %w[. . 1 . .],
  %w[. 1 2 3 .],
  %w[5 6 7 8 9],
  %w[. A B C .],
  %w[. . D . .]
]

BUTTON_TO_XY = {}
XY_TO_BUTTON = {}

KEYBOARD.each_with_index do |line, y|
  line.each_with_index do |button, x|
    unless button == '.'
      BUTTON_TO_XY[button] = [x, y]
      XY_TO_BUTTON[[x, y]] = button
    end
  end
end

class Dialer
  attr_accessor :x, :y

  def initialize(button)
    @x, @y = button_to_xy(button)
  end

  def button
    xy_to_button(@x, @y)
  end

  def move!(directions)
    directions.gsub(/[^RULD]/, '').chars.each do |direction|
      case direction
      when 'R'
        @x += 1 unless xy_to_button(@x + 1, @y).nil?
      when 'U'
        @y -= 1 unless xy_to_button(@x, @y - 1).nil?
      when 'L'
        @x -= 1 unless xy_to_button(@x - 1, @y).nil?
      when 'D'
        @y += 1 unless xy_to_button(@x, @y + 1).nil?
      else
        raise "Direction #{direction.inspect} invalid!"
      end
    end

    button
  end

  private

  def button_to_xy(button)
    BUTTON_TO_XY[button]
  end

  def xy_to_button(x, y)
    XY_TO_BUTTON[[x, y]]
  end
end

dialer = Dialer.new("5")
input = readlines("input.txt")

combination =
  input.map do |line|
    dialer.move!(line)
  end

puts combination.join
