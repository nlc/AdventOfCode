NUMERIC_LAYOUT = [
  %w[7 8 9],
  %w[4 5 6],
  %w[1 2 3],
  [nil, '0', 'A'],
].reverse
NUMERIC_LOCS = {}
NUMERIC_BUTTONS = {}
NUMERIC_LAYOUT.each_with_index do |line, y|
  line.each_with_index do |button, x|
    loc = [x, y]

    unless button.nil?
      NUMERIC_LOCS[button] = loc
      NUMERIC_BUTTONS[loc] = button
    end
  end
end

DIRECTIONAL_LAYOUT = [
  [nil, '^', 'A'],
  %w[< v >]
].reverse
DIRECTIONAL_LOCS = {}
DIRECTIONAL_BUTTONS = {}
DIRECTIONAL_LAYOUT.each_with_index do |line, y|
  line.each_with_index do |button, x|
    loc = [x, y]

    unless button.nil?
      DIRECTIONAL_LOCS[button] = loc
      DIRECTIONAL_BUTTONS[loc] = button
    end
  end
end


shortest_numeric = {}
NUMERIC_LOCS.each do |orig_button, orig_loc|
  NUMERIC_LOCS.each do |orig_button, dest_loc|
    shortest_numeric[orig_button]
  end
end

shortest_directional = {}
