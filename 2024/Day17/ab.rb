def execute(iptr, registers, program)
  instruction = program[iptr]
  return [iptr, registers, nil, false] if instruction.nil?

  literal_operand = program[iptr + 1]

  combo_operand =
    case literal_operand
    when 0..3
      literal_operand
    when 4..6
      registers[literal_operand - 4]
    end

  a, b, c = registers

  output = nil

  case instruction
  when 0
    a >>= combo_operand
  when 1
    b ^= literal_operand
  when 2
    b = combo_operand & 7
  when 3
    if a.zero?
      iptr += 2
    else
      iptr = literal_operand
    end
  when 4
    b ^= c
  when 5
    output = combo_operand & 7
  when 6
    b = a >> combo_operand
  when 7
    c = a >> combo_operand
  end

  iptr += 2 unless instruction == 3

  return [iptr, [a, b, c], output, true]
end

def run_program(registers, program)
  iptr = 0
  output = nil
  outputs = []
  running = true

  while running
    iptr, registers, output, running = execute(iptr, registers, program)
    outputs << output unless output.nil?
  end

  outputs.join(',')
end

def day17a(registers, program)
  run_program(registers, program)
end

def day17b(registers, program)
  # considerations:
  # no guarantee of avoiding infinite loops now, most likely gotta check for that

  # Nothing up to 25,000,000 so far
  1000.times do |a|
    iptr = 0
    output = nil
    outputs = []
    running = true

    registers = [a, 0, 0]

    while running
      iptr, registers, output, running = execute(iptr, registers, program)
      outputs << output unless output.nil?
    end

    puts "=== #{a} === : #{outputs} | R #{registers.inspect}"

    return a if program == outputs
  end

  return nil
end


registers_str, program_str = File.read('input.txt').split(/\n\n/)
registers = registers_str.split(/\n/).map { |line| line.split(/: */).last.to_i }
program = program_str.split(/: */).last.split(/,/).map(&:to_i)

p day17b(registers, program)
