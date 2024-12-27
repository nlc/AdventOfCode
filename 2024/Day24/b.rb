def assemble_binary(bool_arr)
  bool_arr.map { |bool| bool ? '1' : '0' }.join.to_i(2)
end

def disassemble_binary(num)
  num.to_s(2).chars.map { |ch| ch == '1' }
end

def set_initials(initials, x_value, y_value)
  disassemble_binary(x_value)
  disassemble_binary(y_value)

  x_initials = initials.keys.select { |k| k =~ /^x/ }
  y_initials = initials.keys.select { |k| k =~ /^y/ }
end

def evaluate(wire, initials, inflows)
  return initials[wire] if initials.key?(wire)

  op, i1, i2 = inflows[wire]
  v1 = evaluate(i1, initials, inflows)
  v2 = evaluate(i2, initials, inflows)

  case op
  when 'AND'
    v1 && v2
  when 'OR'
    v1 || v2
  when 'XOR'
    v1 ^ v2
  else
    raise "illegal operator #{op.inspect}"
  end
end


initials_str, connections_str = File.read('input.txt').split(/\n\n/)

initials =
  initials_str.split(/\n/).map do |line|
    wire, value_str = line.match(/^(...): ([01])/).to_a[1..2]
    [wire, value_str == "1"]
  end.to_h

output_wires = []
inflows =
  connections_str.split(/\n/).map do |line|
    i1, op, i2, out = line.match(/^(...) (AND|OR|XOR) (...) -> (...)/)[1..4]

    output_wires << out if out =~ /^z\d\d/

    [out, [op, i1, i2]]
  end.to_h
output_wires.sort!.reverse!



def get_misses(initials, inflows, output_wires)
  x_initials = initials.select { |k, _| k =~ /^x/ }.map(&:last)
  y_initials = initials.select { |k, _| k =~ /^y/ }.map(&:last)

  x_num = assemble_binary(x_initials)
  y_num = assemble_binary(y_initials)

  result = x_num + y_num

  curr_result = assemble_binary(output_wires.map { |wire| evaluate(wire, initials, inflows) })
  p curr_result
  p curr_result ^ result
  puts (curr_result ^ result).to_s(2)
end

get_misses(initials, inflows, output_wires)
