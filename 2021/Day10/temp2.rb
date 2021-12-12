stack = []
OPENS = ['(', '[', '{', '<'].freeze
CLOSES = [')', ']', '}', '>'].freeze
OPENS_FOR = CLOSES.zip(OPENS).to_h
l.chars.each_with_index do |ch, i|
  if OPENS.include? ch
    stack.push ch
  elsif CLOSES.include? ch
    unless stack.pop == OPENS_FOR[ch]
      puts i
      break
    end
  end
end
