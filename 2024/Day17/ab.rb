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

def try(a, program)
  iptr = 0
  output = nil
  outputs = []
  running = true

  registers = [a, 0, 0]

  while running
    iptr, registers, output, running = execute(iptr, registers, program)
    outputs << output unless output.nil?
  end

  outputs
end

def fitness(a, program)
  output = try(a, program)

  return 0 if output.length != program.length

  # program.zip(output).count { |a, b| a == b } # attempt 1: unweighted
  program.zip(output).map.with_index { |ab, i| (ab[0] == ab[1] ? 1 : 0) * (i + 1) }.sum # attempt 2: weighted
  # program.zip(output).map.with_index { |ab, i| 1 / ((ab[0] - ab[1]).abs + 1).to_f }.sum # attempt 3: abs diff
  # program.zip(output).map.with_index { |ab, i| (i + 1) / ((ab[0] - ab[1]).abs + 1).to_f }.sum # attempt 4: abs diff with weight
  # program.zip(output).map.with_index { |ab, i| (i + 1) / ((ab[0] - ab[1]).abs + 1).to_f }.sum * (program[0] == output[0] ? 1.1 : 1.0) # attempt 5: abs diff with weight, bonus for first
end

def day17b_old(registers, program)
  # considerations:
  # no guarantee of avoiding infinite loops now, most likely gotta check for that

  # Nothing up to 50,000,000 so far
  # Only produces up to 9 digits of output, but we need 16
  # Maybe hazard an ansatz that the output length grows roughly monotonically
  # with the size of register A, and ping higher and higher numbers until
  # we're in the neighborhood
  # seems by that method like it might be somewhere in 162000000000000..168000000000000

  (164516454000000..164516460000000).each do |a|
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

def day17b(registers, program)
  # left_bound = 1
  # right_bound = 10000000000000000

  # left_bound = 150000000000000
  # right_bound = 170000000000000
  # right_bound = 164532461254233

  # left_bound  = 164400000000000
  left_bound  = 164516454000000
  right_bound = 164516455000000

  # left_bound = 164533534308000
  # right_bound = 164533534372800

  # almost exact for 164533534345504
  #

  nslices = 20001

  best_fitness_so_far = 0

  loop do
    slice_size = [((right_bound - left_bound) / nslices).to_i, 1].max

    puts "#{left_bound}..#{right_bound} by #{slice_size}s"

    ping_idxs = (nslices + 1).times.map do |slice_idx|
      left_bound + slice_size * slice_idx
    end

    fits =
      ping_idxs.map do |ping_idx|
        fitness(ping_idx, program)
      end

    p max_fitness = fits.max
    if max_fitness <= best_fitness_so_far
      puts "max fitness dipped!"
      nslices *= 2
      redo
    elsif max_fitness > best_fitness_so_far
      best_fitness_so_far = max_fitness
    end

    best_fit_idxs = fits.filter_map.with_index { |fit, i| i if fit == max_fitness }

    if best_fit_idxs.length == 0
      raise 'wut'
    elsif best_fit_idxs.length == 1 # naively presume it's in this single range
      best_fit_idx = best_fit_idxs[0]
      puts "best fit(#{max_fitness}) at #{ping_idxs[best_fit_idx]}: #{try(ping_idxs[best_fit_idxs[0]], program) }"
      left_bound = ping_idxs[best_fit_idx - 1] || ping_idxs.first
      right_bound = ping_idxs[best_fit_idx + 1] || ping_idxs.last
    else
      nslices *= 2
    end

    if slice_size == 1
      puts "best fit(#{max_fitness})"
      best_fit_idxs.each do |best_fit_idx|
        puts "  #{ping_idxs[best_fit_idx]}: #{try(ping_idxs[best_fit_idxs[0]], program)}"
      end
      break
    end
  end

  return nil
end

# 164534168944570 is too high
# 164532461459539 is too high
# 164532461254233 is too high
# 160000000000000 is just wrong

# maybe 164528166626686..164528166627782  ?
# isn't 164531681480000..164531681560000 but it was suggestive

# 164531715010493 gives [2, 4, 1, 1, 7, 5, 1, 3*, 2*, 4*, 4, 4, 5, 5, 3, 0] EXTREMELY CLOSE
# 164531753089461 gives [2, 4, 1, 1, 7, 3*, 1, 5, 0, 4*, 4, 4, 5, 5, 3, 0]
# 164533500017077: [2, 4, 1, 1, 7, 5, 1, 5, 4*, 3, 4, 4, 5, 5, 3, 0] !!! even though it's too high
# 164532511927997: [2, 4, 1, 1, 7, 5, 1, 5, 2*, 3, 4, 4, 5, 5, 3, 0]

# okay, found *A* quine input--just probably not the smallest:
# 164532461596349: [2, 4, 1, 1, 7, 5, 1, 5, 0, 3, 4, 4, 5, 5, 3, 0]
# 164532461596605: [2, 4, 1, 1, 7, 5, 1, 5, 0, 3, 4, 4, 5, 5, 3, 0]
# 164516454365621 <---

registers_str, program_str = File.read('input.txt').split(/\n\n/)
registers = registers_str.split(/\n/).map { |line| line.split(/: */).last.to_i }
program = program_str.split(/: */).last.split(/,/).map(&:to_i)

p day17b_old(registers, program)

# finally solved... by brutal trial and error
