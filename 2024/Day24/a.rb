initials_str, connections_str = File.read('input.txt').split(/\n\n/)

$initials =
  initials_str.split(/\n/).map do |line|
    wire, value_str = line.match(/^(...): ([01])/).to_a[1..2]
    [wire, value_str == "1"]
  end.to_h

$output_wires = []
$inflows =
  connections_str.split(/\n/).map do |line|
    i1, op, i2, out = line.match(/^(...) (AND|OR|XOR) (...) -> (...)/)[1..4]

    $output_wires << out if out =~ /^z\d\d/

    [out, [op, i1, i2]]
  end.to_h
$output_wires.sort!.reverse!

$state = {} # state should be 1-to-1 with each input configuration
def evaluate(wire)
  return $state[wire] if $state.key?(wire)

  return $initials[wire] if $initials.key?(wire)

  op, i1, i2 = $inflows[wire]
  v1 = evaluate(i1)
  v2 = evaluate(i2)

  $state[wire] =
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

def assemble_binary(bool_arr)
  bool_arr.map do |bool|
    bool ? '1' : '0'
  end.join.to_i(2)
end

p assemble_binary($output_wires.map { |wire| evaluate(wire) })
