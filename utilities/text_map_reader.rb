require './graph.rb'

def add(a, b)
  a.zip(b) { |ea, eb| ea + eb }
end

def sub(a, b)
  a.zip(b) { |ea, eb| ea - eb }
end

class TextMapReader
  def read_text_map(fname, wall='#', open=' ')
    walls =
      if wall.kind_of?(Array)
        wall
      elsif wall.kind_of?(String)
        [wall]
      else
        raise "Unknown type for #{wall.inspect}"
      end

    opens =
      if open.kind_of?(Array)
        open
      elsif open.kind_of?(String)
        [open]
      else
        raise "Unknown type for #{open.inspect}"
      end

    lines = File.readlines(fname, chomp: true)

    width = lines.first.length
    height = lines.length

    open_indices = {}
    num_opens = 0
    lines.each_with_index do |l, i|
      diff = len - l.length
      if diff != 0
        lines[i] += ' ' * diff
      end

      l.chars.each_with_index do |ch, j|
        if opens.include? ch
          open_indices[[i, j]] = num_opens
          num_opens += 1
        end
      end
    end

    n = 0
    connectivity_matrix = Array.new(height) { Array.new(width) }
    height.times do |i|
      width.times do |j|
        open_index = open_indices[[i, j]]

        do
          connectivity_matrix[open_index]
        end
      end
    end
  end
end

tmr = TextMapReader.new

tmr.read_text_map 'test_map.txt'
