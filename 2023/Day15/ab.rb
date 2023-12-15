def hash_algo(str)
  str.chars.reduce(0){|s, char|((s + char.ord) * 17) % 256}
end

def day15a(input)
  input.sum do |step|
    hash_algo(step)
  end
end

def day15b(input)
  boxes = {}
  input.each do |inst|
    boxstr = inst.gsub(/[\-=].*/, '')
    boxnum = hash_algo(boxstr)
    boxes[boxnum] = {} unless boxes.key?(boxnum)

    if inst =~ /-/
      delvalue, delindex = boxes[boxnum].delete(boxstr)

      unless delindex.nil?
        boxes[boxnum].each do |boxstr, (value, index)|
          if index > delindex
            boxes[boxnum][boxstr][1] -= 1 unless boxes[boxnum][boxstr].empty?
          end
        end
      end
    elsif inst =~ /=/
      value = inst.gsub(/.*=/, '').to_i

      index = boxes[boxnum][boxstr].nil? ? boxes[boxnum].length : boxes[boxnum][boxstr][1]

      boxes[boxnum][boxstr] = [value, index]
    end

    # puts "After \"#{inst}\":"
    # boxes.each do |boxnum, box|
    #   if box.any?
    #     print "Box #{boxnum}: "
    #     box.each do |boxstr, (value, index)|
    #       print "#{index}[#{boxstr} #{value}] "
    #     end
    #     puts
    #   end
    # end
    # puts
  end

  boxes.sum do |boxnum, box|
    box.sum do |boxstr, (value, index)|
      focusing_power = (1 + boxnum) * (1 + index) * value
      # puts "#{(1 + boxnum)} * #{(1 + index)} * #{value} = #{focusing_power}"
    end
  end
end

fname = ARGV.shift || 'input.txt'

input = File.read(fname).gsub(/\n/, '').split(',')

puts 'Day 15:'
puts "  Part A: #{day15a(input)}"
puts "  Part B: #{day15b(input)}"
