opcodes = {
  1 => {
    code: 1,
    name: 'ADD',
    nparams: 3
  },
  2 => {
    code: 2,
    name: 'MUL',
    nparams: 3
  },
  3 => {
    code: 3,
    name: 'INP',
    nparams: 1
  },
  4 => {
    code: 4,
    name: 'OUT',
    nparams: 1
  },
  5 => {
    code: 5,
    name: 'JIT',
    nparams: 2
  },
  6 => {
    code: 6,
    name: 'JIF',
    nparams: 2
  },
  7 => {
    code: 7,
    name: 'LES',
    nparams: 3
  },
  8 => {
    code: 8,
    name: 'EQU',
    nparams: 3
  },
  99 => {
    code: 99,
    name: 'HAL',
    nparams: 0
  }
}

memory = File.read('input.txt').split(/,/).map{|n|n.to_i}
# memory = File.read('sample.txt').split(/,/).map{|n|n.to_i}
ipointer = 0

loop do
  # Read extended opcode
  if(ipointer >= memory.length)
    raise "unexpected end of input at #{ipointer}"
  end
  instruction = memory[ipointer]
  opcode = opcodes[instruction % 100] # last two digits of instruction
  if opcode == nil
    raise "illegal instruction #{instruction} at #{ipointer}"
  end

  # 0 is Position Mode
  # 1 is Immediate Mode
  modes = opcode[:nparams].times.map do |i|
    mode = (instruction / (10**(i + 2))) % 10
    if [0, 1].include? mode
      mode
    else
      raise "illegal mode #{mode}"
    end
  end

  params = modes.map.with_index do |mode, i|
    memory[ipointer + 1 + i]
  end

  # puts opcode[:name]
  # p modes
  # p params

  # Execute
  jumped = false
  case opcode[:name]
  when 'ADD'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])
    argb = (modes[1] == 0) ? (memory[params[1]]) : (params[1])
    optr = params[2]

    memory[optr] = arga + argb
  when 'MUL'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])
    argb = (modes[1] == 0) ? (memory[params[1]]) : (params[1])
    optr = params[2]

    memory[optr] = arga * argb
  when 'INP'
    optr = params[0]
    print '? '

    memory[optr] = gets.chomp.to_i
  when 'OUT'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])

    puts arga
  when 'JIT'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])
    argb = (modes[1] == 0) ? (memory[params[1]]) : (params[1])

    if arga != 0
      ipointer = argb
      jumped = true
    end
  when 'JIF'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])
    argb = (modes[1] == 0) ? (memory[params[1]]) : (params[1])

    if arga == 0
      ipointer = argb
      jumped = true
    end
  when 'LES'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])
    argb = (modes[1] == 0) ? (memory[params[1]]) : (params[1])
    optr = params[2]

    memory[optr] = (arga < argb) ? 1 : 0
  when 'EQU'
    arga = (modes[0] == 0) ? (memory[params[0]]) : (params[0])
    argb = (modes[1] == 0) ? (memory[params[1]]) : (params[1])
    optr = params[2]

    memory[optr] = (arga == argb) ? 1 : 0
  when 'HAL'
    exit
  else
    raise "no logic implemented for opcode #{opcode[:code]} ('#{opcode[:name]})"
  end

  # Advance instruction pointer
  unless jumped
    ipointer += opcode[:nparams] + 1
  end
end
