arr = File.read('input.txt').split(/,/).map{|n|n.to_i}

# the "input"
if ARGV.length > 1
  arr[1] = ARGV.shift.to_i
  arr[2] = ARGV.shift.to_i
else
  arr[1] = 12
  arr[2] = 2
end

operator = nil
val1 = nil
val2 = nil

state = :opcode
arr.each_with_index do |n, i|
  case state
    when :opcode
      if n == 1 # add
        operator = :+
      elsif n == 2 # multiply
        operator = :*
      elsif n == 99 # print and exit
        puts arr.first
        exit
      else
        raise "illegal opcode #{n} at position #{i}"
      end

      state = :iptr1
    when :iptr1
      val1 = arr[n]
      state = :iptr2
    when :iptr2
      val2 = arr[n]
      state = :optr
    when :optr
      arr[n] = [val1, val2].inject(operator)
      state = :opcode
    else
      raise "entered illegal state"
  end
end

raise "reached end of instructions without receiving stop code"
